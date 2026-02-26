import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../core/api/api_client.dart';
import '../core/api/api_endpoints.dart';

class StripeService {
  final ApiClient _apiClient = ApiClient();

  /// Handles the entire deposit flow
  /// 1. Create verification intent
  /// 2. Initialize payment sheet
  /// 3. Present payment sheet
  /// 4. Confirm payment with backend
  Future<Map<String, dynamic>> handleDeposit(double amount) async {
    try {
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
    } catch (e) {
      print('StripeService: Error: $e');
      rethrow;
    }
  }
}
