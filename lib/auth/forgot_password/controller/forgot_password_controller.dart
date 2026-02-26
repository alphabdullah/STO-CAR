import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

/// Forgot password controller (MVC pattern - Controller layer)
class ForgotPasswordController extends GetxController {
  final _email = ''.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isSuccess = false.obs;

  String get email => _email.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;
  bool get isSuccess => _isSuccess.value;

  void setEmail(String value) => _email.value = value;

  Future<void> resetPassword(BuildContext context) async {
    if (!_validateInputs()) return;

    _isLoading.value = true;
    _errorMessage.value = '';
    _isSuccess.value = false;

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock: In real app, this would send reset email
      _isSuccess.value = true;

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent! Please check your inbox.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }

      // Navigate back after a delay
      await Future.delayed(const Duration(seconds: 2));
      if (context.mounted) {
        context.pop();
      }
    } catch (e) {
      _errorMessage.value = 'Failed to send reset email. Please try again.';
    } finally {
      _isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (_email.value.isEmpty) {
      _errorMessage.value = 'Please enter your email';
      return false;
    }
    if (!_email.value.contains('@')) {
      _errorMessage.value = 'Please enter a valid email';
      return false;
    }
    return true;
  }
}

