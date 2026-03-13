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
