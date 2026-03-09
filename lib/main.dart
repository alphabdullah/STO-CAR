import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';
import 'state/auth_state.dart';
import 'state/locale_state.dart';
import 'state/theme_state.dart';
import 'package:sto_car_app/l10n/app_localizations.dart';
import 'state/auction_state.dart';
import 'state/parts_state.dart';
import 'state/booking_state.dart';
import 'state/admin_stats_state.dart';
import 'features/auctions/controller/auction_controller.dart';
import 'admin/auctions/controller/admin_auction_controller.dart';
import 'core/storage/storage_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'core/constants/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  if (!kIsWeb) {
    Stripe.publishableKey = AppConstants.stripePublishableKey;
    Stripe.merchantIdentifier = AppConstants.stripeMerchantIdentifier;
    try {
      await Stripe.instance.applySettings();
    } catch (e) {
      debugPrint('Stripe init error: $e');
    }
  }

  // Initialize storage service
  final storageService = StorageService();
  await storageService.init();

  // Initialize state management
  Get.put(ThemeState());
  final authState = Get.put(AuthState());
  Get.put(AuctionState());
  Get.put(AuctionController());
  Get.put(AdminAuctionController());
  Get.put(PartsState());
  Get.put(BookingState());
  Get.put(AdminStatsState());
  Get.put(LocaleState());

  try {
    await authState.autoLogin();
  } catch (e) {
    print('Main: autoLogin exception: $e');
  }

  runApp(const STOApp());
}

class STOApp extends StatelessWidget {
  const STOApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final localeState = Get.find<LocaleState>();
      final themeState = Get.find<ThemeState>();

      return MaterialApp.router(
        title: 'STO Car Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeState.themeMode,
        routerConfig: AppRouter.router,
        locale: localeState.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      );
    });
  }
}
