import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'l10n/app_localizations.dart';
import 'l10n/language_provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/initial_loading_screen.dart';
import 'utils/navigation_service.dart';
import 'data/services/notification_service.dart';
import 'data/services/crashlytics_service.dart';
import 'data/services/analytics_service.dart';
import 'data/services/remote_config_service.dart';
import 'data/services/cloudinary_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file (Cloudinary config)
  await dotenv.load(fileName: '.env');

  // Khoi tao Firebase (bat buoc truoc runApp)
  await Firebase.initializeApp();

  // Khoi tao Crashlytics — bat loi Flutter framework va async errors
  await CrashlyticsService.instance.initialize();

  // Dang ky background handler (phai la top-level function)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Khoi tao Remote Config (fetch cau hinh tu xa)
  await RemoteConfigService.instance.initialize();

  // Khoi tao Cloudinary
  CloudinaryService.instance.initialize();

  // Enable true edge-to-edge full screen display without top/bottom black bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Load saved theme and language preferences from local storage before rendering UI
  final initialThemeMode = await ThemeProvider.loadSavedThemeMode();
  final initialLocale = await LanguageProvider.loadSavedLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initialTheme: initialThemeMode),
        ),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider(initialLocale: initialLocale),
        ),
      ],
      child: const GroceryApp(),
    ),
  );
}


class GroceryApp extends StatelessWidget {
  const GroceryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return ScreenUtilInit(
          // Kích thước màn hình thiết bị dùng để thiết kế/test gốc.
          // Thay bằng kích thước đúng của điện thoại bạn đang test nếu khác.
          designSize: const Size(412, 915),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            navigatorKey: NavigationService.navigatorKey,
            // Gắn Analytics observer để tự động theo dõi screen views
            navigatorObservers: [AnalyticsService.instance.observer],
            title: 'Friggy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: languageProvider.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: child,
          ),
          child: const InitialLoadingScreen(),
        );
      },
    );
  }
}
