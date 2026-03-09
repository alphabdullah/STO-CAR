import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

class StripeService {
  final ApiClient _apiClient = ApiClient();

  static const String _unsupportedPlatformMessage =
      'Card deposit is available in the Android and iOS app. Please use the app on your phone.';

  /// Handles the entire deposit flow
  /// - Web: Stripe Checkout (opens in new tab)
  /// - Android/iOS: Payment Sheet
  /// - Windows: Message to use mobile app
  Future<Map<String, dynamic>> handleDeposit(double amount) async {
    try {
      // Web (Chrome, etc.) uses Stripe Checkout - check first
      if (kIsWeb) {
        return await _handleDepositWeb(amount);
      }
      // Windows desktop app - no Payment Sheet support
      if (GetPlatform.isWindows) {
        throw Exception(_unsupportedPlatformMessage);
      }

      // Mobile: Use Payment Sheet
      print('StripeService: Creating verification intent for amount: $amount');
      // 1. Create verification intent
      final intentResponse = await _apiClient.post(
        ApiEndpoints.createVerificationIntent,
        body: {'amount': amount.toInt()},
        requiresAuth: true,
      );

      print('StripeService: Intent response: $intentResponse');

      if (intentResponse['success'] != true) {
        throw Exception(intentResponse['message'] ?? 'Failed to create payment intent');
      }

      final data = intentResponse['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('Invalid verification intent response');
      final clientSecret = data['client_secret']?.toString();
      final paymentIntentId = data['payment_intent_id']?.toString();
      if (clientSecret == null || clientSecret.isEmpty || paymentIntentId == null) {
        throw Exception('Missing client_secret or payment_intent_id from server');
      }
      
      print('StripeService: clientSecret: $clientSecret');
      print('StripeService: paymentIntentId: $paymentIntentId');

      // 2. Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'STO Car Marketplace',
          style: ThemeMode.light,
        ),
      );

      // 3. Present payment sheet
      print('StripeService: Presenting payment sheet...');
      await Stripe.instance.presentPaymentSheet();
      print('StripeService: Payment sheet completed.');

      // 4. Retrieve payment intent to get the actual payment method ID
      final paymentIntent = await Stripe.instance.retrievePaymentIntent(clientSecret);
      final paymentMethodId = paymentIntent.paymentMethodId;
      if (paymentMethodId == null || paymentMethodId.isEmpty) {
        throw Exception('Could not retrieve payment method from Stripe');
      }
      print('StripeService: paymentMethodId: $paymentMethodId');

      // 5. Confirm payment with backend using actual payment method ID
      print('StripeService: Confirming payment with backend...');
      final confirmBody = <String, dynamic>{
        'payment_intent_id': paymentIntentId,
        'payment_method_id': paymentMethodId,
      };
      print('StripeService: Confirm body: $confirmBody');

      final confirmResponse = await _apiClient.post(
        ApiEndpoints.confirmStripePayment,
        body: confirmBody,
        requiresAuth: true,
      );
      
      print('StripeService: Confirm response: $confirmResponse');

      return confirmResponse;
    } on StripeException catch (e) {
      print('StripeService: StripeException: ${e.error.localizedMessage}');
      if (e.error.localizedMessage != null) {
        throw Exception(e.error.localizedMessage);
      }
      rethrow;
    } on MissingPluginException catch (_) {
      throw Exception(_unsupportedPlatformMessage);
    } catch (e) {
      print('StripeService: Error: $e');
      if (e.toString().contains('StripeConfigException') ||
          e.toString().contains('MissingPluginException')) {
        throw Exception(_unsupportedPlatformMessage);
      }
      rethrow;
    }
  }

  /// Web: Create Checkout Session and open Stripe Checkout
  Future<Map<String, dynamic>> _handleDepositWeb(double amount) async {
    final base = Uri.base;
    final path = base.path.isEmpty || base.path.endsWith('/')
        ? base.path
        : base.path + '/';
    final baseUrl = '${base.origin}$path';
    final successUrl = '${baseUrl}wallet?payment=success';
    final cancelUrl = '${baseUrl}wallet?payment=cancelled';

    final response = await _apiClient.post(
      ApiEndpoints.createCheckoutSession,
      body: {
        'amount': amount.toInt(),
        'success_url': successUrl,
        'cancel_url': cancelUrl,
      },
      requiresAuth: true,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create checkout');
    }

    final data = response['data'] as Map<String, dynamic>?;
    final url = data?['url']?.toString();
    if (url == null || url.isEmpty) {
      throw Exception('Backend did not return checkout URL. Add checkout-session endpoint.');
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return {
        'success': true,
        'message': 'Payment window opened. Complete payment there, then return here.',
      };
    }
    throw Exception('Could not open payment page.');
  }

  /// Verify Checkout Session after redirect (credit wallet) - for web
  Future<Map<String, dynamic>> verifyCheckoutSession(String sessionId) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyCheckoutSession,
      body: {'session_id': sessionId},
      requiresAuth: true,
    );
    return response;
  }
}
