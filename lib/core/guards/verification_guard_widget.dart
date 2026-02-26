import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import '../../state/auth_state.dart';

/// Widget that guards content requiring verified user (wallet deposit)
/// Shows verification prompt instead of blocking access
class VerificationGuardWidget extends StatelessWidget {
  final Widget child;
  final String? actionDescription;
  final bool inline;

  const VerificationGuardWidget({
    super.key,
    required this.child,
    this.actionDescription,
    this.inline = false,
  });

  @override
  Widget build(BuildContext context) {
    final authState = AuthState();
    
    if (!authState.isAuthenticated) {
      if (inline) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Login required',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.push(AppConstants.routeLogin),
              child: const Text(AppStrings.login),
            ),
          ],
        );
      }

      return Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Login Required',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text('Please login first'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.push(AppConstants.routeLogin);
                  },
                  child: const Text(AppStrings.login),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isVerified = authState.currentUser?.isVerified ?? false;
    if (!isVerified) {
      if (inline) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.verificationRequired,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => context.push(AppConstants.routeWallet),
              icon: const Icon(Icons.account_balance_wallet),
              label: const Text(AppStrings.depositNow),
            ),
          ],
        );
      }

      return _buildVerificationPrompt(context);
    }

    return child;
  }

  Widget _buildVerificationPrompt(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.verified_user_outlined,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.verificationRequired,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.verificationDescription,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_balance_wallet, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${AppConstants.requiredWalletDeposit} ${AppConstants.currency}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.push(AppConstants.routeWallet);
                },
                icon: const Icon(Icons.account_balance_wallet),
                label: const Text(AppStrings.depositNow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

