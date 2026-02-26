import '../../state/auth_state.dart';
import '../constants/app_constants.dart';

/// Verification guard for wallet deposit requirement
class VerificationGuard {
  VerificationGuard._();

  static final AuthState _authState = AuthState();

  /// Check if user is verified (has deposited 4500 AED)
  static bool isVerified() {
    return _authState.currentUser?.isVerified ?? false;
  }

  /// Get verification status message
  static String getVerificationMessage() {
    return 'To ${_getActionDescription()}, please deposit ${AppConstants.requiredWalletDeposit} ${AppConstants.currency} to verify your account.';
  }

  static String _getActionDescription() {
    // This would be context-specific, but for now return generic message
    return 'participate in auctions and purchase parts';
  }
}

