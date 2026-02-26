import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../state/auth_state.dart';
import '../../models/user_model.dart';

/// Authentication guard for route protection
class AuthGuard {
  AuthGuard._();

  static final AuthState _authState = AuthState();

  /// Check if user is authenticated, redirect to login if not
  static String? check(BuildContext context) {
    if (!_authState.isAuthenticated) {
      return AppConstants.routeLogin;
    }
    return null;
  }

  /// Check if user is admin, redirect to home if not
  static String? checkAdmin(BuildContext context) {
    if (!_authState.isAuthenticated) {
      return AppConstants.routeLogin;
    }
    if (_authState.currentUser?.role != UserRole.admin) {
      return AppConstants.routeUserHome;
    }
    return null;
  }
}

