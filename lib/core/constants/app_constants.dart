/// Application-wide constants
class AppConstants {
  AppConstants._();

  // Wallet
  static const double requiredWalletDeposit = 4500.0; // AED
  static const String currency = 'AED';

  // Auction
  static const int auctionDurationHours = 72;
  static const double minBidIncrement = 100.0;

  // Routes
  static const String routeHome = '/';
  static const String routeSplash = '/splash';
  static const String routeLogin = '/login';
  static const String routeSignup = '/signup';
  static const String routeForgotPassword = '/forgot-password';
  
  // Feature Routes (Shared by Guest and User)
  static const String routeHomeFeature = '/home';
  static const String routeAuctions = '/auctions';
  static const String routeAuctionDetails = '/auctions/:id';
  static const String routeParts = '/parts';
  static const String routeCart = '/cart';
  static const String routePurchaseHistory = '/purchase-history';
  static const String routeBookings = '/bookings';
  static const String routeNewBooking = '/bookings/new';
  static const String routeWallet = '/wallet';
  static const String routeProfile = '/profile';
  static const String routeNotifications = '/notifications';
  
  // Legacy routes for backward compatibility (will redirect)
  static const String routeGuestHome = '/guest/home';
  static const String routeUserHome = '/user/home';
  static const String routeUserWallet = '/wallet'; // Alias
  static const String routeUserProfile = '/profile'; // Alias
  
  // Admin Routes
  static const String routeAdminDashboard = '/admin/dashboard';
  static const String routeAdminAuctions = '/admin/auctions';
  static const String routeAdminParts = '/admin/parts';
  static const String routeAdminBookings = '/admin/bookings';
  static const String routeAdminOrders = '/admin/orders';
  static const String routeAdminSettings = '/admin/settings';
  static const String routeFormFieldEditor = '/admin/bookings/form-fields';

  // Stripe
  static const String stripePublishableKey = 'pk_test_51RE5Jx2erDAmayX4DCTfsC9Qtj533KAvCNGRbMiD3fCIouIv9JEYsTr7R1mXF1ac2GL4gU54pTR9KPy1LMZWOCIf00QJckKGJD';
  /// Required by Stripe SDK for Payment Sheet. Use any identifier for test.
  static const String stripeMerchantIdentifier = 'merchant.stocar.marketplace';
}


