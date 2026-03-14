// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'STO Car Marketplace';

  @override
  String get welcomeBack => 'Welcome!';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get searchHint => 'Search for Vehicles, Parts, Services...';

  @override
  String get exploreCategories => 'Explore Categories';

  @override
  String get carAuctions => 'Car Auctions';

  @override
  String get stoPerformance => 'STO Performance';

  @override
  String get performanceParts => 'Performance Parts';

  @override
  String get getVerified => 'Get Verified';

  @override
  String get notifications => 'Notifications';

  @override
  String get home => 'Home';

  @override
  String get auctions => 'Auctions';

  @override
  String get parts => 'Parts';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phone => 'Phone Number';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get purchaseHistory => 'Purchase History';

  @override
  String get cart => 'Cart';

  @override
  String get wallet => 'Wallet';

  @override
  String get booking => 'Service Booking';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get guest => 'Guest';

  @override
  String get verifiedAccount => 'Verified Account';

  @override
  String get notVerified => 'Not Verified';

  @override
  String get liveAuctions => 'Live Auctions';

  @override
  String get viewAll => 'View All';

  @override
  String get unlockFullAccess => 'Unlock Full Access';

  @override
  String get joinEliteCommunity =>
      'Join our elite community of car enthusiasts.';

  @override
  String get loginNow => 'Login Now';

  @override
  String get register => 'Register';

  @override
  String get serviceBooking => 'Service Booking';

  @override
  String get bookService => 'Book a Service';

  @override
  String get companies => 'Companies';

  @override
  String get languageChanged => 'Language changed';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get role => 'Role';

  @override
  String get memberSince => 'Member Since';

  @override
  String get emiratesId => 'Emirates ID';

  @override
  String get frontSide => 'Front Side';

  @override
  String get backSide => 'Back Side';

  @override
  String get appTheme => 'App Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get logoutTitle => 'Logout';

  @override
  String get logoutMessage => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String lotNumber(Object id) {
    return 'Lot #$id';
  }

  @override
  String get bids => 'Bids';

  @override
  String get time => 'Time';

  @override
  String get currentBid => 'Current Bid';

  @override
  String get live => 'LIVE';

  @override
  String get auctionNotFound => 'Auction not found';

  @override
  String get backToAuctions => 'Back to Auctions';

  @override
  String get loadingAuction => 'Loading auction...';

  @override
  String get description => 'Description';

  @override
  String get winningBid => 'Winning Bid';

  @override
  String get outbid => 'Outbid';

  @override
  String get timeLeft => 'Time Left';

  @override
  String get totalBids => 'Total Bids';

  @override
  String get endingSoon => 'Ending soon';

  @override
  String get loginToPlaceBid => 'Login to Place Bid';

  @override
  String get verificationRequired => 'Verification Required';

  @override
  String get verifyAccountToPlaceBids =>
      'Please verify your account to place bids';

  @override
  String get verifyNow => 'Verify Now';

  @override
  String get updateBid => 'Update Bid';

  @override
  String get placeBid => 'Place Bid';

  @override
  String get noLiveAuctions => 'No Live Auctions';

  @override
  String get noLiveAuctionsMessage =>
      'There are currently no live auctions available';

  @override
  String get noBidsYet => 'No Bids Yet';

  @override
  String get loginToViewBiddedAuctions => 'Login to view your bidded auctions';

  @override
  String get noBidsPlacedMessage =>
      'You haven\'t placed any bids on live auctions';

  @override
  String get noClosedAuctions => 'No Closed Auctions';

  @override
  String get loginToViewClosedAuctions => 'Login to view your closed auctions';

  @override
  String get noClosedAuctionsOutbid =>
      'You don\'t have any closed auctions where you were outbid';

  @override
  String get myBids => 'My Bids';

  @override
  String get closed => 'Closed';

  @override
  String placeBidTitle(Object title) {
    return 'Place Bid - $title';
  }

  @override
  String minimumBidAed(Object amount) {
    return 'Minimum bid is $amount AED';
  }

  @override
  String get bidAmount => 'Bid Amount';

  @override
  String get bidPlacedSuccess => 'Bid placed successfully!';

  @override
  String get bidPlaceFailed => 'Failed to place bid. Please try again.';

  @override
  String bidPlaceFailedWithError(Object message) {
    return 'Failed to place bid: $message';
  }

  @override
  String get featuredMarketplace => 'Featured Marketplace';

  @override
  String viewingProductsFrom(Object name) {
    return 'Viewing products from $name';
  }

  @override
  String showingSpecializedComponents(Object count) {
    return 'Showing $count specialized components';
  }

  @override
  String get advancedFilters => 'Advanced Filters';

  @override
  String get noPartsFound => 'No Parts Found';

  @override
  String get noPartsFoundMessage =>
      'Try adjusting your filters or search query';

  @override
  String get productAddedToCart => 'Product successfully added to cart';

  @override
  String get resetAll => 'Reset All';

  @override
  String get condition => 'Condition';

  @override
  String get priceRangeAed => 'Price Range (AED)';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get partsStore => 'Parts Store';

  @override
  String get explorePremiumComponents => 'Explore Premium Components';

  @override
  String get searchPartsHint => 'Search parts, brands, OEM...';

  @override
  String get featured => 'FEATURED';

  @override
  String get shopByBrand => 'Shop by Brand';

  @override
  String get allBrands => 'All Brands';

  @override
  String get noPartsAvailable => 'No Parts Available';

  @override
  String get noPartsAvailableMessage =>
      'This company doesn\'t have any parts listed yet';

  @override
  String get inStock => 'In Stock';

  @override
  String get outOfStock => 'Out of Stock';

  @override
  String get price => 'Price';

  @override
  String get available => 'Available';

  @override
  String get verifyAccountToPurchaseParts =>
      'Verify your account to purchase parts';

  @override
  String get purchase => 'Purchase';

  @override
  String get noPurchasesYet => 'No purchases yet';

  @override
  String get purchaseHistoryEmptyMessage =>
      'Parts you purchase will appear here';

  @override
  String get browseParts => 'Browse Parts';

  @override
  String get seller => 'Seller';

  @override
  String get tracking => 'Tracking';

  @override
  String get purchaseFailed => 'Purchase failed. Please try again.';

  @override
  String get partInventoryNumber => 'Part Inventory #';

  @override
  String get oemReferenceNumber => 'OEM Reference #';

  @override
  String get compatibility => 'Compatibility';

  @override
  String get yearCompatibility => 'Year Compatibility';

  @override
  String get present => 'Present';

  @override
  String get stockStatus => 'Stock Status';

  @override
  String unitsAvailable(Object count) {
    return '$count Units available';
  }

  @override
  String get contactForRestocking => 'Contact for restocking';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get verifyAccountToPurchase => 'Verify account to purchase';

  @override
  String purchasedSuccess(Object name) {
    return '$name purchased successfully!';
  }

  @override
  String get serviceBookings => 'Service Bookings';

  @override
  String bookingCount(Object count) {
    return '$count booking';
  }

  @override
  String bookingsCount(Object count) {
    return '$count bookings';
  }

  @override
  String get loginToViewBookings => 'Login to view and create bookings';

  @override
  String get loginToViewProfile => 'Please login to view your profile';

  @override
  String get loginToViewWallet => 'Please login to view your wallet';

  @override
  String get loginToViewPurchaseHistory =>
      'Please login to view your purchase history';

  @override
  String get pleaseLoginToContinue => 'Please login to continue';

  @override
  String get noBookingsYet => 'No Bookings Yet';

  @override
  String get bookFirstServiceAppointment =>
      'Book your first service appointment';

  @override
  String get viewDetails => 'View Details';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get date => 'Date';

  @override
  String get phoneShort => 'Phone';

  @override
  String get bookingNumber => 'Booking #';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get back => 'Back';

  @override
  String get enterFullName => 'Enter your full name';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get carName => 'Car Name';

  @override
  String get carNameHint => 'e.g., BMW, Mercedes';

  @override
  String get carModel => 'Car Model';

  @override
  String get carModelHint => 'e.g., 3 Series, C-Class';

  @override
  String get enterServiceDescription =>
      'Enter service description or additional notes';

  @override
  String get preferredDate => 'Preferred Date';

  @override
  String get selectPreferredDate => 'Select preferred date';

  @override
  String get preferredTime => 'Preferred Time';

  @override
  String get selectPreferredTime => 'Select preferred time';

  @override
  String get submitBooking => 'Submit Booking';

  @override
  String get bookingDetails => 'Booking Details';

  @override
  String get createdAt => 'Created At';

  @override
  String get adminNotes => 'Admin Notes';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterPhoneNumber => 'Please enter your phone number';

  @override
  String get pleaseEnterCarModel => 'Please enter car model';

  @override
  String get pleaseEnterCarName => 'Please enter car name';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseSelectTime => 'Please select a time';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get rememberPassword => 'Remember your password? ';

  @override
  String get forgotPasswordTitle => 'Forgot Password';

  @override
  String get forgotPasswordMessage =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get tapToUpload => 'Tap to upload';

  @override
  String get uploadEmiratesId => 'Upload Emirates ID';

  @override
  String get uploadEmiratesIdMessage =>
      'Please upload both the front and back of your Emirates Card for verification.';

  @override
  String get confirmPasswordHint => 'Confirm your password';

  @override
  String get adminDashboard => 'Dashboard';

  @override
  String get adminOverview => 'Admin Overview';

  @override
  String get statisticsOverview => 'Statistics Overview';

  @override
  String get auctionRevenue => 'Auction Revenue';

  @override
  String get partsRevenue => 'Parts Revenue';

  @override
  String get totalAuctions => 'Total Auctions';

  @override
  String get pendingAuctions => 'Pending Auctions';

  @override
  String get partsAvailable => 'Parts Available';

  @override
  String get bookingsToday => 'Bookings Today';

  @override
  String get pendingBookings => 'Pending Bookings';

  @override
  String get totalUsers => 'Total Users';

  @override
  String get verifiedUsers => 'Verified Users';

  @override
  String get visualAnalytics => 'Visual Analytics';

  @override
  String get retry => 'Retry';

  @override
  String get allMetrics => 'All Metrics';

  @override
  String get totalParts => 'Total Parts';

  @override
  String get totalBookings => 'Total Bookings';

  @override
  String get pendingApproval => 'Pending Approval';

  @override
  String get allTime => 'All Time';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get barChart => 'Bar Chart';

  @override
  String get pieChart => 'Pie Chart';

  @override
  String get lineChart => 'Line Chart';

  @override
  String get statisticsComparison => 'Statistics Comparison';

  @override
  String get distributionOverview => 'Distribution Overview';

  @override
  String get trendAnalysis => 'Trend Analysis';

  @override
  String get chartLabelAuctions => 'Auctions';

  @override
  String get chartLabelLive => 'Live';

  @override
  String get chartLabelPending => 'Pending';

  @override
  String get chartLabelParts => 'Parts';

  @override
  String get chartLabelBookings => 'Bookings';

  @override
  String get chartLabelPendingB => 'Pending B';

  @override
  String get chartLabelUsers => 'Users';

  @override
  String get chartLabelVerified => 'Verified';

  @override
  String get manageAuctions => 'Manage Auctions';

  @override
  String get manageAndApproveAuctions => 'Manage and approve auctions';

  @override
  String get noPendingAuctions => 'No Pending Auctions';

  @override
  String get allAuctionsReviewed => 'All auctions have been reviewed';

  @override
  String get noAuctions => 'No Auctions';

  @override
  String get noAuctionsCreatedYet => 'No auctions have been created yet';

  @override
  String get editAuctionPrice => 'Edit Auction Price';

  @override
  String get startingBidAed => 'Starting Bid (AED)';

  @override
  String get currentBidAedOptional => 'Current Bid (AED) - optional';

  @override
  String get bidIncrementAed => 'Bid Increment (AED)';

  @override
  String get save => 'Save';

  @override
  String get invalidStartingBid => 'Invalid starting bid';

  @override
  String get allAuctionsTab => 'All Auctions';

  @override
  String get startingBid => 'Starting Bid';

  @override
  String get editPrice => 'Edit Price';

  @override
  String get statusPending => 'PENDING';

  @override
  String get statusApproved => 'APPROVED';

  @override
  String get statusLive => 'LIVE';

  @override
  String get statusClosed => 'CLOSED';

  @override
  String get statusRejected => 'REJECTED';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get failedToLoadPendingAuctions =>
      'Failed to load pending auctions. Please try again.';

  @override
  String get auctionApprovedSuccessfully => 'Auction approved successfully';

  @override
  String get auctionRejected => 'Auction rejected';

  @override
  String get failedToApproveAuction =>
      'Failed to approve auction. Please try again.';

  @override
  String get failedToRejectAuction =>
      'Failed to reject auction. Please try again.';

  @override
  String get auctionPriceUpdatedSuccessfully =>
      'Auction price updated successfully';

  @override
  String get failedToUpdateAuction =>
      'Failed to update auction. Please try again.';

  @override
  String get manageBookings => 'Manage Bookings';

  @override
  String get manageAndApproveBookings => 'Manage and approve bookings';

  @override
  String get noPendingBookings => 'No Pending Bookings';

  @override
  String get allBookingsReviewed => 'All bookings have been reviewed';

  @override
  String get noBookings => 'No Bookings';

  @override
  String get noBookingsCreatedYet => 'No bookings have been created yet';

  @override
  String get allBookingsTab => 'All Bookings';

  @override
  String get created => 'Created';

  @override
  String get bookingApprovedSuccessfully => 'Booking approved successfully';

  @override
  String get bookingRejectedSuccessfully => 'Booking rejected';

  @override
  String get rejectBookingTitle => 'Reject Booking';

  @override
  String get rejectBookingMessage =>
      'Are you sure you want to reject this booking?';

  @override
  String get rejectionReasonRequired => 'Rejection reason is required';

  @override
  String get rejectionReason => 'Rejection Reason *';

  @override
  String get rejectionReasonHint => 'e.g., Service not available';

  @override
  String get additionalNotes => 'Additional Notes';

  @override
  String get additionalNotesHint => 'Please choose another date';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get user => 'User';

  @override
  String get status => 'Status';

  @override
  String get vehicleDetails => 'Vehicle Details';

  @override
  String get car => 'Car';

  @override
  String get model => 'Model';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get descriptionNotes => 'Description/Notes';

  @override
  String get close => 'Close';

  @override
  String get pending => 'Pending';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get completed => 'Completed';

  @override
  String get formFieldsUpdatedSuccessfully =>
      'Form fields updated successfully';

  @override
  String get editFormFields => 'Edit Form Fields';

  @override
  String get customizeBookingFormFields => 'Customize booking form fields';

  @override
  String get customizeFormDescription =>
      'Customize the booking form fields. Users will see these fields when creating a booking.';

  @override
  String get newField => 'New Field';

  @override
  String get addNewField => 'Add New Field';

  @override
  String get noFieldsAddedYet => 'No fields added yet';

  @override
  String get tapAddNewFieldHint =>
      'Tap \"Add New Field\" to create your first field';

  @override
  String get fieldLabel => 'Field Label';

  @override
  String get fieldLabelHint => 'Enter field label';

  @override
  String get fieldType => 'Field Type';

  @override
  String get placeholderOptional => 'Placeholder (Optional)';

  @override
  String get placeholderHint => 'Enter placeholder text';

  @override
  String get optionsCommaSeparated => 'Options (comma-separated)';

  @override
  String get optionsHint => 'Option 1, Option 2, Option 3';

  @override
  String get orders => 'Orders';

  @override
  String get partPurchasesAndOrderHistory => 'Part purchases & order history';

  @override
  String get filterAll => 'All';

  @override
  String get paid => 'Paid';

  @override
  String get shipped => 'Shipped';

  @override
  String get delivered => 'Delivered';

  @override
  String get noOrdersYet => 'No Orders Yet';

  @override
  String get partPurchasesWillAppearHere => 'Part purchases will appear here';

  @override
  String get buyer => 'Buyer';

  @override
  String get address => 'Address';

  @override
  String get orderNumber => 'Order #';

  @override
  String get soldParts => 'Sold Parts';

  @override
  String get oneSaleRecorded => '1 sale recorded';

  @override
  String salesRecordedCount(int count) {
    return '$count sales recorded';
  }

  @override
  String get noSalesRecorded => 'No Sales Recorded';

  @override
  String get noPartsSoldYet => 'No parts have been sold yet';

  @override
  String get addPart => 'Add Part';

  @override
  String get editPart => 'Edit Part';

  @override
  String get quantity => 'Quantity';

  @override
  String get unit => 'unit';

  @override
  String get units => 'units';

  @override
  String get totalLabel => 'Total';

  @override
  String get soldOn => 'Sold on';

  @override
  String get company => 'Company';

  @override
  String get partName => 'Part Name';

  @override
  String get category => 'Category';

  @override
  String get priceAed => 'Price (AED)';

  @override
  String get stockQuantity => 'Stock Quantity';

  @override
  String get pleaseFillRequiredFields => 'Please fill all required fields';

  @override
  String get partUpdatedSuccessfully => 'Part updated successfully';

  @override
  String get partAddedSuccessfully => 'Part added successfully';

  @override
  String get deletePart => 'Delete Part';

  @override
  String get deletePartConfirm => 'Are you sure you want to delete this part?';

  @override
  String get partDeletedSuccessfully => 'Part deleted successfully';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String minAgo(int count) {
    return '$count min ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hour ago';
  }

  @override
  String hoursAgoPlural(int count) {
    return '$count hours ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String get settings => 'Settings';

  @override
  String get stripeAccount => 'Stripe Account';

  @override
  String get stripeAccountDescription =>
      'Configure your Stripe account. Payments from users will go to this account.';

  @override
  String get stripeIsConfigured => 'Stripe is configured';

  @override
  String get publishableKeyLabel =>
      'Publishable Key (pk_live_... or pk_test_...)';

  @override
  String get publishableKeyHint => 'pk_live_... or pk_test_...';

  @override
  String get secretKeyLabel => 'Secret Key (sk_live_... or sk_test_...)';

  @override
  String get secretKeyHint => 'sk_live_... or sk_test_...';

  @override
  String get leaveBlankToKeepCurrent => 'Leave blank to keep current';

  @override
  String secretKeyCurrent(String masked) {
    return 'Current: $masked';
  }

  @override
  String get webhookSecretLabel => 'Webhook Secret (whsec_...) - Optional';

  @override
  String get webhookSecretHint => 'whsec_...';

  @override
  String get saveSettings => 'Save Settings';

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully';

  @override
  String get loginRequiredToViewCart => 'Login required to view cart';

  @override
  String get yourCartIsEmpty => 'Your cart is empty';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get checkout => 'Checkout';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get enterShippingAddress => 'Enter shipping address';

  @override
  String get fullAddressHint => 'Full address, city, postal code';

  @override
  String get pleaseEnterShippingAddress => 'Please enter shipping address';

  @override
  String purchaseCompleteTotal(String amount) {
    return 'Purchase complete! Total: $amount';
  }

  @override
  String get confirmPurchase => 'Confirm Purchase';
}
