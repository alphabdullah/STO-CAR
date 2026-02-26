import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../state/auth_state.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/user_model.dart';
import '../../../core/api/api_client.dart' as api;

/// Login controller (MVC pattern - Controller layer)
class LoginController extends GetxController {
  final AuthState _authState = AuthState();

  final _email = ''.obs;
  final _password = ''.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _isPasswordVisible = false.obs;

  String get email => _email.value;
  String get password => _password.value;
  bool get isLoading => _isLoading.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  String? get errorMessage => _errorMessage.value.isEmpty ? null : _errorMessage.value;

  void setEmail(String value) => _email.value = value;
  void setPassword(String value) => _password.value = value;
  void togglePasswordVisibility() => _isPasswordVisible.value = !_isPasswordVisible.value;

  Future<void> login(BuildContext context) async {
    if (!_validateInputs()) return;

    _isLoading.value = true;
    _errorMessage.value = '';

    try {
      // Try admin login first if email contains 'admin', otherwise use regular login
      // The API response will contain the actual role
      if (_email.value.toLowerCase().contains('admin')) {
        await _authState.adminLogin(
          email: _email.value,
          password: _password.value,
        );
      } else {
        await _authState.login(
          email: _email.value,
          password: _password.value,
        );
      }

      // Navigate based on role from API response using GoRouter
      if (!context.mounted) return;
      final role = _authState.currentRole;
      final user = _authState.currentUser;
      
      print('LoginController: Login successful');
      print('LoginController: User name: ${user?.name}');
      print('LoginController: User email: ${user?.email}');
      print('LoginController: User role from API: ${user?.role}');
      print('LoginController: Current role getter: $role');
      
      if (role == UserRole.admin) {
        print('LoginController: Navigating to ADMIN dashboard');
        context.go(AppConstants.routeAdminDashboard);
      } else {
        print('LoginController: Navigating to USER home');
        context.go(AppConstants.routeHomeFeature);
      }
    } on api.ApiException catch (e) {
      _errorMessage.value = e.message;
    } catch (e) {
      _errorMessage.value = 'Login failed. Please try again.';
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
    if (_password.value.isEmpty) {
      _errorMessage.value = 'Please enter your password';
      return false;
    }
    if (_password.value.length < 6) {
      _errorMessage.value = 'Password must be at least 6 characters';
      return false;
    }
    return true;
  }
}

