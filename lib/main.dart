import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:fly_journey/src/features/splash/presentation/screens/splash_screen.dart';
import 'package:fly_journey/src/features/home/presentation/screens/main_screen.dart';
import 'package:fly_journey/src/features/auth/presentation/screens/login_screen.dart';
import 'package:fly_journey/src/features/auth/presentation/screens/register_screen.dart';
import 'package:fly_journey/src/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';
import 'package:fly_journey/src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);

  // Load user data from SharedPreferences
  await AuthService().loadUserData();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool _showSplash = true;
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_isFirstLaunch) {
      // Show splash screen when app is resumed (not first launch)
      setState(() {
        _showSplash = true;
      });
    }
  }

  void _hideSplash() {
    setState(() {
      _showSplash = false;
      _isFirstLaunch = false; // Mark that first launch is completed
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fly Journey',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      themeMode: ThemeMode.system,
      home: _showSplash
          ? SplashScreen(
              onFinished: _hideSplash,
              isFirstLaunch: _isFirstLaunch,
            )
          : const MainScreen(),
      routes: {
        '/main': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          final initialTab = args?['initialTab'] as int? ?? 0;
          return MainScreen(initialIndex: initialTab);
        },
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/otp-verification': (context) => const OtpVerificationScreen(),
      },
    );
  }
}
