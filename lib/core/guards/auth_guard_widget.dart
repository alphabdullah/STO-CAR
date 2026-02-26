import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import '../../state/auth_state.dart';

/// Widget that guards content requiring authentication
/// Shows login prompt instead of blocking access
class AuthGuardWidget extends StatelessWidget {
  final Widget child;
  final String? actionDescription;

  const AuthGuardWidget({
    super.key,
    required this.child,
    this.actionDescription,
  });

  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    
    if (!authState.isAuthenticated) {
      return _buildLoginPrompt(context);
    }

    return child;
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                'Login Required',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                actionDescription ?? 'Please login to continue',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  context.push(AppConstants.routeLogin);
                },
                child: const Text(AppStrings.login),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  context.push(AppConstants.routeSignup);
                },
                child: const Text(AppStrings.signup),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

