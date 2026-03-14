import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/guards/auth_guard.dart';
import '../../state/auth_state.dart';
import '../../models/user_model.dart';
import '../../core/splash/view/splash_screen.dart';
import '../../auth/login/view/login_screen.dart';
import '../../auth/signup/view/signup_screen.dart';
import '../../auth/forgot_password/view/forgot_password_screen.dart';
// Feature screens (unified for guest and user)
import '../../features/home/view/home_screen.dart';
import '../../features/auctions/view/auctions_screen.dart';
import '../../features/auctions/view/auction_details_screen.dart';
import '../../features/parts/view/parts_screen.dart';
import '../../features/parts/view/company_parts_screen.dart';
import '../../features/parts/view/purchase_history_screen.dart';
import '../../features/cart/view/cart_screen.dart';
import '../../features/bookings/view/bookings_screen.dart';
import '../../features/bookings/view/new_booking_screen.dart';
import '../../features/wallet/view/user_wallet_screen.dart';
import '../../features/profile/view/user_profile_screen.dart';
import '../../features/notifications/view/notifications_screen.dart';
// Admin screens
import '../../admin/dashboard/view/admin_dashboard_screen.dart';
import '../../admin/auctions/view/admin_auctions_screen.dart';
import '../../admin/parts/view/admin_parts_screen.dart';
import '../../admin/bookings/view/admin_bookings_screen.dart';
import '../../admin/orders/view/admin_orders_screen.dart';
import '../../admin/settings/view/admin_settings_screen.dart';
import '../../admin/bookings/view/form_field_editor_screen.dart';

/// Centralized routing configuration with role-aware navigation
class AppRouter {
  AppRouter._();

  static final AuthState _authState = AuthState();
  
  // Singleton router instance to preserve across hot reloads
  // On hot reload: instance persists, current route is preserved
  // On hot restart: instance is null, new router created with splash as initial location
  static GoRouter? _routerInstance;

  static GoRouter get router {
    // Return existing instance if available (preserves state across hot reloads)
    if (_routerInstance != null) {
      return _routerInstance!;
    }
    
    // Create new router on app startup or hot restart
    // Always start at splash screen - splash will check SharedPreferences and navigate
    _routerInstance = GoRouter(
      initialLocation: AppConstants.routeSplash,
      redirect: (context, state) {
        // Don't redirect from splash screen
        if (state.uri.path == AppConstants.routeSplash) {
          return null;
        }

        final isAuthenticated = _authState.isAuthenticated;
        final userRole = _authState.currentUser?.role;

        final isAuthRoute = state.uri.path == AppConstants.routeLogin ||
            state.uri.path == AppConstants.routeSignup ||
            state.uri.path == AppConstants.routeForgotPassword;

        // Redirect authenticated users away from auth screens
        if (isAuthenticated && isAuthRoute) {
          return _getHomeRouteForRole(userRole);
        }

        // Legacy route redirects
        if (state.uri.path == AppConstants.routeGuestHome ||
            state.uri.path == AppConstants.routeUserHome) {
          return AppConstants.routeHomeFeature;
        }

        // Do not redirect protected feature routes to login here.
        // Let the user land on the screen; each screen shows an in-screen
        // login prompt (AuthGuardWidget). That way "Login" uses push and
        // back from login returns to the previous screen instead of closing the app.

        return null;
      },
      routes: [
        // Splash Route
        GoRoute(
          path: AppConstants.routeSplash,
          builder: (context, state) => const SplashScreen(),
        ),
        // Auth Routes
        GoRoute(
          path: AppConstants.routeLogin,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppConstants.routeSignup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: AppConstants.routeForgotPassword,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),

        // Feature Routes (Shared by Guest and User)
        GoRoute(
          path: AppConstants.routeHomeFeature,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppConstants.routeAuctions,
          builder: (context, state) => const AuctionsScreen(),
        ),
        GoRoute(
          path: '/auctions/:id',
          builder: (context, state) {
            final auctionId = state.pathParameters['id'] ?? '';
            return AuctionDetailsScreen(auctionId: auctionId);
          },
        ),
        GoRoute(
          path: AppConstants.routeParts,
          builder: (context, state) => const PartsScreen(),
        ),
        GoRoute(
          path: '${AppConstants.routeParts}/:companyId',
          builder: (context, state) {
            final companyId = state.pathParameters['companyId'] ?? '';
            return CompanyPartsScreen(companyId: companyId);
          },
        ),
        GoRoute(
          path: AppConstants.routeCart,
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: AppConstants.routeBookings,
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: AppConstants.routeNewBooking,
          builder: (context, state) => const NewBookingScreen(),
        ),
        GoRoute(
          path: AppConstants.routeWallet,
          builder: (context, state) => const UserWalletScreen(),
        ),
        GoRoute(
          path: AppConstants.routeProfile,
          builder: (context, state) => const UserProfileScreen(),
        ),
        GoRoute(
          path: AppConstants.routeNotifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: AppConstants.routePurchaseHistory,
          builder: (context, state) => const PurchaseHistoryScreen(),
        ),

        // Legacy Routes (Redirect to new routes)
        GoRoute(
          path: AppConstants.routeGuestHome,
          redirect: (context, state) => AppConstants.routeHomeFeature,
        ),
        GoRoute(
          path: AppConstants.routeUserHome,
          redirect: (context, state) => AppConstants.routeHomeFeature,
        ),

        // Admin Routes (Protected)
        GoRoute(
          path: AppConstants.routeAdminDashboard,
          builder: (context, state) => const AdminDashboardScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
        GoRoute(
          path: AppConstants.routeAdminAuctions,
          builder: (context, state) => const AdminAuctionsScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
        GoRoute(
          path: AppConstants.routeAdminParts,
          builder: (context, state) => const AdminPartsScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
        GoRoute(
          path: AppConstants.routeAdminBookings,
          builder: (context, state) => const AdminBookingsScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
        GoRoute(
          path: AppConstants.routeAdminOrders,
          builder: (context, state) => const AdminOrdersScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
        GoRoute(
          path: AppConstants.routeAdminSettings,
          builder: (context, state) => const AdminSettingsScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
        GoRoute(
          path: AppConstants.routeFormFieldEditor,
          builder: (context, state) => const FormFieldEditorScreen(),
          redirect: (context, state) => AuthGuard.checkAdmin(context),
        ),
      ],
    );
    
    return _routerInstance!;
  }

  static String _getHomeRouteForRole(UserRole? role) {
    switch (role) {
      case UserRole.admin:
        return AppConstants.routeAdminDashboard;
      case UserRole.user:
      default:
        return AppConstants.routeHomeFeature;
    }
  }
}

