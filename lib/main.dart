
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'providers/auth_provider.dart';

import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/attendee_profile_screen.dart';

import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization is required by the application.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Register background notification handler.
    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  // Notifications must never prevent the app from opening.
  try {
    await NotificationService.instance.initialize();
  } catch (e, stackTrace) {
    debugPrint('Notification initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  // Start the application regardless of notification initialization.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: const WowYouAttendeeApp(),
    ),
  );
}

class WowYouAttendeeApp extends StatelessWidget {
  const WowYouAttendeeApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WowYou Attendee',
      theme: AppTheme.dark,
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const MainNavigationScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/profile-onboarding': (_) =>
            const AttendeeProfileScreen(),
      },
    );
  }
}
