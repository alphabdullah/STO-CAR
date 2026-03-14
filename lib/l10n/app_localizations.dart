import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'STO Car Marketplace'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for Vehicles, Parts, Services...'**
  String get searchHint;

  /// No description provided for @exploreCategories.
  ///
  /// In en, this message translates to:
  /// **'Explore Categories'**
  String get exploreCategories;

  /// No description provided for @carAuctions.
  ///
  /// In en, this message translates to:
  /// **'Car Auctions'**
  String get carAuctions;

  /// No description provided for @stoPerformance.
  ///
  /// In en, this message translates to:
  /// **'STO Performance'**
  String get stoPerformance;

  /// No description provided for @performanceParts.
  ///
  /// In en, this message translates to:
  /// **'Performance Parts'**
  String get performanceParts;

  /// No description provided for @getVerified.
  ///
  /// In en, this message translates to:
  /// **'Get Verified'**
  String get getVerified;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @auctions.
  ///
  /// In en, this message translates to:
  /// **'Auctions'**
  String get auctions;

  /// No description provided for @parts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get parts;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @purchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Purchase History'**
  String get purchaseHistory;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Service Booking'**
  String get booking;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @verifiedAccount.
  ///
  /// In en, this message translates to:
  /// **'Verified Account'**
  String get verifiedAccount;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not Verified'**
  String get notVerified;

  /// No description provided for @liveAuctions.
  ///
  /// In en, this message translates to:
  /// **'Live Auctions'**
  String get liveAuctions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @unlockFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Unlock Full Access'**
  String get unlockFullAccess;

  /// No description provided for @joinEliteCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join our elite community of car enthusiasts.'**
  String get joinEliteCommunity;

  /// No description provided for @loginNow.
  ///
  /// In en, this message translates to:
  /// **'Login Now'**
  String get loginNow;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @serviceBooking.
  ///
  /// In en, this message translates to:
  /// **'Service Booking'**
  String get serviceBooking;

  /// No description provided for @bookService.
  ///
  /// In en, this message translates to:
  /// **'Book a Service'**
  String get bookService;

  /// No description provided for @companies.
  ///
  /// In en, this message translates to:
  /// **'Companies'**
  String get companies;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @memberSince.
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// No description provided for @emiratesId.
  ///
  /// In en, this message translates to:
  /// **'Emirates ID'**
  String get emiratesId;

  /// No description provided for @frontSide.
  ///
  /// In en, this message translates to:
  /// **'Front Side'**
  String get frontSide;

  /// No description provided for @backSide.
  ///
  /// In en, this message translates to:
  /// **'Back Side'**
  String get backSide;

  /// No description provided for @appTheme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get appTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @lotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot #{id}'**
  String lotNumber(Object id);

  /// No description provided for @bids.
  ///
  /// In en, this message translates to:
  /// **'Bids'**
  String get bids;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @currentBid.
  ///
  /// In en, this message translates to:
  /// **'Current Bid'**
  String get currentBid;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// No description provided for @auctionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Auction not found'**
  String get auctionNotFound;

  /// No description provided for @backToAuctions.
  ///
  /// In en, this message translates to:
  /// **'Back to Auctions'**
  String get backToAuctions;

  /// No description provided for @loadingAuction.
  ///
  /// In en, this message translates to:
  /// **'Loading auction...'**
  String get loadingAuction;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @winningBid.
  ///
  /// In en, this message translates to:
  /// **'Winning Bid'**
  String get winningBid;

  /// No description provided for @outbid.
  ///
  /// In en, this message translates to:
  /// **'Outbid'**
  String get outbid;

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'Time Left'**
  String get timeLeft;

  /// No description provided for @totalBids.
  ///
  /// In en, this message translates to:
  /// **'Total Bids'**
  String get totalBids;

  /// No description provided for @endingSoon.
  ///
  /// In en, this message translates to:
  /// **'Ending soon'**
  String get endingSoon;

  /// No description provided for @loginToPlaceBid.
  ///
  /// In en, this message translates to:
  /// **'Login to Place Bid'**
  String get loginToPlaceBid;

  /// No description provided for @verificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Verification Required'**
  String get verificationRequired;

  /// No description provided for @verifyAccountToPlaceBids.
  ///
  /// In en, this message translates to:
  /// **'Please verify your account to place bids'**
  String get verifyAccountToPlaceBids;

  /// No description provided for @verifyNow.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// No description provided for @updateBid.
  ///
  /// In en, this message translates to:
  /// **'Update Bid'**
  String get updateBid;

  /// No description provided for @placeBid.
  ///
  /// In en, this message translates to:
  /// **'Place Bid'**
  String get placeBid;

  /// No description provided for @noLiveAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Live Auctions'**
  String get noLiveAuctions;

  /// No description provided for @noLiveAuctionsMessage.
  ///
  /// In en, this message translates to:
  /// **'There are currently no live auctions available'**
  String get noLiveAuctionsMessage;

  /// No description provided for @noBidsYet.
  ///
  /// In en, this message translates to:
  /// **'No Bids Yet'**
  String get noBidsYet;

  /// No description provided for @loginToViewBiddedAuctions.
  ///
  /// In en, this message translates to:
  /// **'Login to view your bidded auctions'**
  String get loginToViewBiddedAuctions;

  /// No description provided for @noBidsPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t placed any bids on live auctions'**
  String get noBidsPlacedMessage;

  /// No description provided for @noClosedAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Closed Auctions'**
  String get noClosedAuctions;

  /// No description provided for @loginToViewClosedAuctions.
  ///
  /// In en, this message translates to:
  /// **'Login to view your closed auctions'**
  String get loginToViewClosedAuctions;

  /// No description provided for @noClosedAuctionsOutbid.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any closed auctions where you were outbid'**
  String get noClosedAuctionsOutbid;

  /// No description provided for @myBids.
  ///
  /// In en, this message translates to:
  /// **'My Bids'**
  String get myBids;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @placeBidTitle.
  ///
  /// In en, this message translates to:
  /// **'Place Bid - {title}'**
  String placeBidTitle(Object title);

  /// No description provided for @minimumBidAed.
  ///
  /// In en, this message translates to:
  /// **'Minimum bid is {amount} AED'**
  String minimumBidAed(Object amount);

  /// No description provided for @bidAmount.
  ///
  /// In en, this message translates to:
  /// **'Bid Amount'**
  String get bidAmount;

  /// No description provided for @bidPlacedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Bid placed successfully!'**
  String get bidPlacedSuccess;

  /// No description provided for @bidPlaceFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to place bid. Please try again.'**
  String get bidPlaceFailed;

  /// No description provided for @bidPlaceFailedWithError.
  ///
  /// In en, this message translates to:
  /// **'Failed to place bid: {message}'**
  String bidPlaceFailedWithError(Object message);

  /// No description provided for @featuredMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Featured Marketplace'**
  String get featuredMarketplace;

  /// No description provided for @viewingProductsFrom.
  ///
  /// In en, this message translates to:
  /// **'Viewing products from {name}'**
  String viewingProductsFrom(Object name);

  /// No description provided for @showingSpecializedComponents.
  ///
  /// In en, this message translates to:
  /// **'Showing {count} specialized components'**
  String showingSpecializedComponents(Object count);

  /// No description provided for @advancedFilters.
  ///
  /// In en, this message translates to:
  /// **'Advanced Filters'**
  String get advancedFilters;

  /// No description provided for @noPartsFound.
  ///
  /// In en, this message translates to:
  /// **'No Parts Found'**
  String get noPartsFound;

  /// No description provided for @noPartsFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search query'**
  String get noPartsFoundMessage;

  /// No description provided for @productAddedToCart.
  ///
  /// In en, this message translates to:
  /// **'Product successfully added to cart'**
  String get productAddedToCart;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @priceRangeAed.
  ///
  /// In en, this message translates to:
  /// **'Price Range (AED)'**
  String get priceRangeAed;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @partsStore.
  ///
  /// In en, this message translates to:
  /// **'Parts Store'**
  String get partsStore;

  /// No description provided for @explorePremiumComponents.
  ///
  /// In en, this message translates to:
  /// **'Explore Premium Components'**
  String get explorePremiumComponents;

  /// No description provided for @searchPartsHint.
  ///
  /// In en, this message translates to:
  /// **'Search parts, brands, OEM...'**
  String get searchPartsHint;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'FEATURED'**
  String get featured;

  /// No description provided for @shopByBrand.
  ///
  /// In en, this message translates to:
  /// **'Shop by Brand'**
  String get shopByBrand;

  /// No description provided for @allBrands.
  ///
  /// In en, this message translates to:
  /// **'All Brands'**
  String get allBrands;

  /// No description provided for @noPartsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Parts Available'**
  String get noPartsAvailable;

  /// No description provided for @noPartsAvailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This company doesn\'t have any parts listed yet'**
  String get noPartsAvailableMessage;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @verifyAccountToPurchaseParts.
  ///
  /// In en, this message translates to:
  /// **'Verify your account to purchase parts'**
  String get verifyAccountToPurchaseParts;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @noPurchasesYet.
  ///
  /// In en, this message translates to:
  /// **'No purchases yet'**
  String get noPurchasesYet;

  /// No description provided for @purchaseHistoryEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Parts you purchase will appear here'**
  String get purchaseHistoryEmptyMessage;

  /// No description provided for @browseParts.
  ///
  /// In en, this message translates to:
  /// **'Browse Parts'**
  String get browseParts;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @tracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get tracking;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get purchaseFailed;

  /// No description provided for @partInventoryNumber.
  ///
  /// In en, this message translates to:
  /// **'Part Inventory #'**
  String get partInventoryNumber;

  /// No description provided for @oemReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'OEM Reference #'**
  String get oemReferenceNumber;

  /// No description provided for @compatibility.
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get compatibility;

  /// No description provided for @yearCompatibility.
  ///
  /// In en, this message translates to:
  /// **'Year Compatibility'**
  String get yearCompatibility;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @stockStatus.
  ///
  /// In en, this message translates to:
  /// **'Stock Status'**
  String get stockStatus;

  /// No description provided for @unitsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} Units available'**
  String unitsAvailable(Object count);

  /// No description provided for @contactForRestocking.
  ///
  /// In en, this message translates to:
  /// **'Contact for restocking'**
  String get contactForRestocking;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @verifyAccountToPurchase.
  ///
  /// In en, this message translates to:
  /// **'Verify account to purchase'**
  String get verifyAccountToPurchase;

  /// No description provided for @purchasedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} purchased successfully!'**
  String purchasedSuccess(Object name);

  /// No description provided for @serviceBookings.
  ///
  /// In en, this message translates to:
  /// **'Service Bookings'**
  String get serviceBookings;

  /// No description provided for @bookingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} booking'**
  String bookingCount(Object count);

  /// No description provided for @bookingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bookings'**
  String bookingsCount(Object count);

  /// No description provided for @loginToViewBookings.
  ///
  /// In en, this message translates to:
  /// **'Login to view and create bookings'**
  String get loginToViewBookings;

  /// No description provided for @loginToViewProfile.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your profile'**
  String get loginToViewProfile;

  /// No description provided for @loginToViewWallet.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your wallet'**
  String get loginToViewWallet;

  /// No description provided for @loginToViewPurchaseHistory.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your purchase history'**
  String get loginToViewPurchaseHistory;

  /// No description provided for @pleaseLoginToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get pleaseLoginToContinue;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No Bookings Yet'**
  String get noBookingsYet;

  /// No description provided for @bookFirstServiceAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book your first service appointment'**
  String get bookFirstServiceAppointment;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @phoneShort.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneShort;

  /// No description provided for @bookingNumber.
  ///
  /// In en, this message translates to:
  /// **'Booking #'**
  String get bookingNumber;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get enterFullName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @carName.
  ///
  /// In en, this message translates to:
  /// **'Car Name'**
  String get carName;

  /// No description provided for @carNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., BMW, Mercedes'**
  String get carNameHint;

  /// No description provided for @carModel.
  ///
  /// In en, this message translates to:
  /// **'Car Model'**
  String get carModel;

  /// No description provided for @carModelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., 3 Series, C-Class'**
  String get carModelHint;

  /// No description provided for @enterServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter service description or additional notes'**
  String get enterServiceDescription;

  /// No description provided for @preferredDate.
  ///
  /// In en, this message translates to:
  /// **'Preferred Date'**
  String get preferredDate;

  /// No description provided for @selectPreferredDate.
  ///
  /// In en, this message translates to:
  /// **'Select preferred date'**
  String get selectPreferredDate;

  /// No description provided for @preferredTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred Time'**
  String get preferredTime;

  /// No description provided for @selectPreferredTime.
  ///
  /// In en, this message translates to:
  /// **'Select preferred time'**
  String get selectPreferredTime;

  /// No description provided for @submitBooking.
  ///
  /// In en, this message translates to:
  /// **'Submit Booking'**
  String get submitBooking;

  /// No description provided for @bookingDetails.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetails;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @adminNotes.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes'**
  String get adminNotes;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @pleaseEnterCarModel.
  ///
  /// In en, this message translates to:
  /// **'Please enter car model'**
  String get pleaseEnterCarModel;

  /// No description provided for @pleaseEnterCarName.
  ///
  /// In en, this message translates to:
  /// **'Please enter car name'**
  String get pleaseEnterCarName;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember your password? '**
  String get rememberPassword;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get forgotPasswordMessage;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tapToUpload;

  /// No description provided for @uploadEmiratesId.
  ///
  /// In en, this message translates to:
  /// **'Upload Emirates ID'**
  String get uploadEmiratesId;

  /// No description provided for @uploadEmiratesIdMessage.
  ///
  /// In en, this message translates to:
  /// **'Please upload both the front and back of your Emirates Card for verification.'**
  String get uploadEmiratesIdMessage;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminDashboard;

  /// No description provided for @adminOverview.
  ///
  /// In en, this message translates to:
  /// **'Admin Overview'**
  String get adminOverview;

  /// No description provided for @statisticsOverview.
  ///
  /// In en, this message translates to:
  /// **'Statistics Overview'**
  String get statisticsOverview;

  /// No description provided for @auctionRevenue.
  ///
  /// In en, this message translates to:
  /// **'Auction Revenue'**
  String get auctionRevenue;

  /// No description provided for @partsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Parts Revenue'**
  String get partsRevenue;

  /// No description provided for @totalAuctions.
  ///
  /// In en, this message translates to:
  /// **'Total Auctions'**
  String get totalAuctions;

  /// No description provided for @pendingAuctions.
  ///
  /// In en, this message translates to:
  /// **'Pending Auctions'**
  String get pendingAuctions;

  /// No description provided for @partsAvailable.
  ///
  /// In en, this message translates to:
  /// **'Parts Available'**
  String get partsAvailable;

  /// No description provided for @bookingsToday.
  ///
  /// In en, this message translates to:
  /// **'Bookings Today'**
  String get bookingsToday;

  /// No description provided for @pendingBookings.
  ///
  /// In en, this message translates to:
  /// **'Pending Bookings'**
  String get pendingBookings;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @verifiedUsers.
  ///
  /// In en, this message translates to:
  /// **'Verified Users'**
  String get verifiedUsers;

  /// No description provided for @visualAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Visual Analytics'**
  String get visualAnalytics;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @allMetrics.
  ///
  /// In en, this message translates to:
  /// **'All Metrics'**
  String get allMetrics;

  /// No description provided for @totalParts.
  ///
  /// In en, this message translates to:
  /// **'Total Parts'**
  String get totalParts;

  /// No description provided for @totalBookings.
  ///
  /// In en, this message translates to:
  /// **'Total Bookings'**
  String get totalBookings;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending Approval'**
  String get pendingApproval;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @barChart.
  ///
  /// In en, this message translates to:
  /// **'Bar Chart'**
  String get barChart;

  /// No description provided for @pieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie Chart'**
  String get pieChart;

  /// No description provided for @lineChart.
  ///
  /// In en, this message translates to:
  /// **'Line Chart'**
  String get lineChart;

  /// No description provided for @statisticsComparison.
  ///
  /// In en, this message translates to:
  /// **'Statistics Comparison'**
  String get statisticsComparison;

  /// No description provided for @distributionOverview.
  ///
  /// In en, this message translates to:
  /// **'Distribution Overview'**
  String get distributionOverview;

  /// No description provided for @trendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis'**
  String get trendAnalysis;

  /// No description provided for @chartLabelAuctions.
  ///
  /// In en, this message translates to:
  /// **'Auctions'**
  String get chartLabelAuctions;

  /// No description provided for @chartLabelLive.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get chartLabelLive;

  /// No description provided for @chartLabelPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get chartLabelPending;

  /// No description provided for @chartLabelParts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get chartLabelParts;

  /// No description provided for @chartLabelBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get chartLabelBookings;

  /// No description provided for @chartLabelPendingB.
  ///
  /// In en, this message translates to:
  /// **'Pending B'**
  String get chartLabelPendingB;

  /// No description provided for @chartLabelUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get chartLabelUsers;

  /// No description provided for @chartLabelVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get chartLabelVerified;

  /// No description provided for @manageAuctions.
  ///
  /// In en, this message translates to:
  /// **'Manage Auctions'**
  String get manageAuctions;

  /// No description provided for @manageAndApproveAuctions.
  ///
  /// In en, this message translates to:
  /// **'Manage and approve auctions'**
  String get manageAndApproveAuctions;

  /// No description provided for @noPendingAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Pending Auctions'**
  String get noPendingAuctions;

  /// No description provided for @allAuctionsReviewed.
  ///
  /// In en, this message translates to:
  /// **'All auctions have been reviewed'**
  String get allAuctionsReviewed;

  /// No description provided for @noAuctions.
  ///
  /// In en, this message translates to:
  /// **'No Auctions'**
  String get noAuctions;

  /// No description provided for @noAuctionsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No auctions have been created yet'**
  String get noAuctionsCreatedYet;

  /// No description provided for @editAuctionPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit Auction Price'**
  String get editAuctionPrice;

  /// No description provided for @startingBidAed.
  ///
  /// In en, this message translates to:
  /// **'Starting Bid (AED)'**
  String get startingBidAed;

  /// No description provided for @currentBidAedOptional.
  ///
  /// In en, this message translates to:
  /// **'Current Bid (AED) - optional'**
  String get currentBidAedOptional;

  /// No description provided for @bidIncrementAed.
  ///
  /// In en, this message translates to:
  /// **'Bid Increment (AED)'**
  String get bidIncrementAed;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @invalidStartingBid.
  ///
  /// In en, this message translates to:
  /// **'Invalid starting bid'**
  String get invalidStartingBid;

  /// No description provided for @allAuctionsTab.
  ///
  /// In en, this message translates to:
  /// **'All Auctions'**
  String get allAuctionsTab;

  /// No description provided for @startingBid.
  ///
  /// In en, this message translates to:
  /// **'Starting Bid'**
  String get startingBid;

  /// No description provided for @editPrice.
  ///
  /// In en, this message translates to:
  /// **'Edit Price'**
  String get editPrice;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get statusPending;

  /// No description provided for @statusApproved.
  ///
  /// In en, this message translates to:
  /// **'APPROVED'**
  String get statusApproved;

  /// No description provided for @statusLive.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get statusLive;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'CLOSED'**
  String get statusClosed;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'REJECTED'**
  String get statusRejected;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failedToLoadPendingAuctions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load pending auctions. Please try again.'**
  String get failedToLoadPendingAuctions;

  /// No description provided for @auctionApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Auction approved successfully'**
  String get auctionApprovedSuccessfully;

  /// No description provided for @auctionRejected.
  ///
  /// In en, this message translates to:
  /// **'Auction rejected'**
  String get auctionRejected;

  /// No description provided for @failedToApproveAuction.
  ///
  /// In en, this message translates to:
  /// **'Failed to approve auction. Please try again.'**
  String get failedToApproveAuction;

  /// No description provided for @failedToRejectAuction.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject auction. Please try again.'**
  String get failedToRejectAuction;

  /// No description provided for @auctionPriceUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Auction price updated successfully'**
  String get auctionPriceUpdatedSuccessfully;

  /// No description provided for @failedToUpdateAuction.
  ///
  /// In en, this message translates to:
  /// **'Failed to update auction. Please try again.'**
  String get failedToUpdateAuction;

  /// No description provided for @manageBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage Bookings'**
  String get manageBookings;

  /// No description provided for @manageAndApproveBookings.
  ///
  /// In en, this message translates to:
  /// **'Manage and approve bookings'**
  String get manageAndApproveBookings;

  /// No description provided for @noPendingBookings.
  ///
  /// In en, this message translates to:
  /// **'No Pending Bookings'**
  String get noPendingBookings;

  /// No description provided for @allBookingsReviewed.
  ///
  /// In en, this message translates to:
  /// **'All bookings have been reviewed'**
  String get allBookingsReviewed;

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No Bookings'**
  String get noBookings;

  /// No description provided for @noBookingsCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings have been created yet'**
  String get noBookingsCreatedYet;

  /// No description provided for @allBookingsTab.
  ///
  /// In en, this message translates to:
  /// **'All Bookings'**
  String get allBookingsTab;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @bookingApprovedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking approved successfully'**
  String get bookingApprovedSuccessfully;

  /// No description provided for @bookingRejectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Booking rejected'**
  String get bookingRejectedSuccessfully;

  /// No description provided for @rejectBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reject Booking'**
  String get rejectBookingTitle;

  /// No description provided for @rejectBookingMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reject this booking?'**
  String get rejectBookingMessage;

  /// No description provided for @rejectionReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason is required'**
  String get rejectionReasonRequired;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason *'**
  String get rejectionReason;

  /// No description provided for @rejectionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Service not available'**
  String get rejectionReasonHint;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotes;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Please choose another date'**
  String get additionalNotesHint;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @vehicleDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get vehicleDetails;

  /// No description provided for @car.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get car;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @descriptionNotes.
  ///
  /// In en, this message translates to:
  /// **'Description/Notes'**
  String get descriptionNotes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @formFieldsUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Form fields updated successfully'**
  String get formFieldsUpdatedSuccessfully;

  /// No description provided for @editFormFields.
  ///
  /// In en, this message translates to:
  /// **'Edit Form Fields'**
  String get editFormFields;

  /// No description provided for @customizeBookingFormFields.
  ///
  /// In en, this message translates to:
  /// **'Customize booking form fields'**
  String get customizeBookingFormFields;

  /// No description provided for @customizeFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize the booking form fields. Users will see these fields when creating a booking.'**
  String get customizeFormDescription;

  /// No description provided for @newField.
  ///
  /// In en, this message translates to:
  /// **'New Field'**
  String get newField;

  /// No description provided for @addNewField.
  ///
  /// In en, this message translates to:
  /// **'Add New Field'**
  String get addNewField;

  /// No description provided for @noFieldsAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No fields added yet'**
  String get noFieldsAddedYet;

  /// No description provided for @tapAddNewFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Add New Field\" to create your first field'**
  String get tapAddNewFieldHint;

  /// No description provided for @fieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Field Label'**
  String get fieldLabel;

  /// No description provided for @fieldLabelHint.
  ///
  /// In en, this message translates to:
  /// **'Enter field label'**
  String get fieldLabelHint;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Field Type'**
  String get fieldType;

  /// No description provided for @placeholderOptional.
  ///
  /// In en, this message translates to:
  /// **'Placeholder (Optional)'**
  String get placeholderOptional;

  /// No description provided for @placeholderHint.
  ///
  /// In en, this message translates to:
  /// **'Enter placeholder text'**
  String get placeholderHint;

  /// No description provided for @optionsCommaSeparated.
  ///
  /// In en, this message translates to:
  /// **'Options (comma-separated)'**
  String get optionsCommaSeparated;

  /// No description provided for @optionsHint.
  ///
  /// In en, this message translates to:
  /// **'Option 1, Option 2, Option 3'**
  String get optionsHint;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @partPurchasesAndOrderHistory.
  ///
  /// In en, this message translates to:
  /// **'Part purchases & order history'**
  String get partPurchasesAndOrderHistory;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No Orders Yet'**
  String get noOrdersYet;

  /// No description provided for @partPurchasesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Part purchases will appear here'**
  String get partPurchasesWillAppearHere;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get orderNumber;

  /// No description provided for @soldParts.
  ///
  /// In en, this message translates to:
  /// **'Sold Parts'**
  String get soldParts;

  /// No description provided for @oneSaleRecorded.
  ///
  /// In en, this message translates to:
  /// **'1 sale recorded'**
  String get oneSaleRecorded;

  /// No description provided for @salesRecordedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sales recorded'**
  String salesRecordedCount(int count);

  /// No description provided for @noSalesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No Sales Recorded'**
  String get noSalesRecorded;

  /// No description provided for @noPartsSoldYet.
  ///
  /// In en, this message translates to:
  /// **'No parts have been sold yet'**
  String get noPartsSoldYet;

  /// No description provided for @addPart.
  ///
  /// In en, this message translates to:
  /// **'Add Part'**
  String get addPart;

  /// No description provided for @editPart.
  ///
  /// In en, this message translates to:
  /// **'Edit Part'**
  String get editPart;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'unit'**
  String get unit;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @soldOn.
  ///
  /// In en, this message translates to:
  /// **'Sold on'**
  String get soldOn;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @partName.
  ///
  /// In en, this message translates to:
  /// **'Part Name'**
  String get partName;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priceAed.
  ///
  /// In en, this message translates to:
  /// **'Price (AED)'**
  String get priceAed;

  /// No description provided for @stockQuantity.
  ///
  /// In en, this message translates to:
  /// **'Stock Quantity'**
  String get stockQuantity;

  /// No description provided for @pleaseFillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillRequiredFields;

  /// No description provided for @partUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Part updated successfully'**
  String get partUpdatedSuccessfully;

  /// No description provided for @partAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Part added successfully'**
  String get partAddedSuccessfully;

  /// No description provided for @deletePart.
  ///
  /// In en, this message translates to:
  /// **'Delete Part'**
  String get deletePart;

  /// No description provided for @deletePartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this part?'**
  String get deletePartConfirm;

  /// No description provided for @partDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Part deleted successfully'**
  String get partDeletedSuccessfully;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @minAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} min ago'**
  String minAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hour ago'**
  String hoursAgo(int count);

  /// No description provided for @hoursAgoPlural.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgoPlural(int count);

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @stripeAccount.
  ///
  /// In en, this message translates to:
  /// **'Stripe Account'**
  String get stripeAccount;

  /// No description provided for @stripeAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure your Stripe account. Payments from users will go to this account.'**
  String get stripeAccountDescription;

  /// No description provided for @stripeIsConfigured.
  ///
  /// In en, this message translates to:
  /// **'Stripe is configured'**
  String get stripeIsConfigured;

  /// No description provided for @publishableKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Publishable Key (pk_live_... or pk_test_...)'**
  String get publishableKeyLabel;

  /// No description provided for @publishableKeyHint.
  ///
  /// In en, this message translates to:
  /// **'pk_live_... or pk_test_...'**
  String get publishableKeyHint;

  /// No description provided for @secretKeyLabel.
  ///
  /// In en, this message translates to:
  /// **'Secret Key (sk_live_... or sk_test_...)'**
  String get secretKeyLabel;

  /// No description provided for @secretKeyHint.
  ///
  /// In en, this message translates to:
  /// **'sk_live_... or sk_test_...'**
  String get secretKeyHint;

  /// No description provided for @leaveBlankToKeepCurrent.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep current'**
  String get leaveBlankToKeepCurrent;

  /// No description provided for @secretKeyCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: {masked}'**
  String secretKeyCurrent(String masked);

  /// No description provided for @webhookSecretLabel.
  ///
  /// In en, this message translates to:
  /// **'Webhook Secret (whsec_...) - Optional'**
  String get webhookSecretLabel;

  /// No description provided for @webhookSecretHint.
  ///
  /// In en, this message translates to:
  /// **'whsec_...'**
  String get webhookSecretHint;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save Settings'**
  String get saveSettings;

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get settingsSavedSuccessfully;

  /// No description provided for @loginRequiredToViewCart.
  ///
  /// In en, this message translates to:
  /// **'Login required to view cart'**
  String get loginRequiredToViewCart;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @enterShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter shipping address'**
  String get enterShippingAddress;

  /// No description provided for @fullAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Full address, city, postal code'**
  String get fullAddressHint;

  /// No description provided for @pleaseEnterShippingAddress.
  ///
  /// In en, this message translates to:
  /// **'Please enter shipping address'**
  String get pleaseEnterShippingAddress;

  /// No description provided for @purchaseCompleteTotal.
  ///
  /// In en, this message translates to:
  /// **'Purchase complete! Total: {amount}'**
  String purchaseCompleteTotal(String amount);

  /// No description provided for @confirmPurchase.
  ///
  /// In en, this message translates to:
  /// **'Confirm Purchase'**
  String get confirmPurchase;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
