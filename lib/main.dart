import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "providers/auth_provider.dart";

import "screens/splash_screen.dart";
import "screens/main_navigation_screen.dart";
import "screens/login_screen.dart";
import "screens/register_screen.dart";
import "screens/attendee_profile_screen.dart";

import "theme/app_theme.dart";

void main() {
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

      title: "WowYou Attendee",

      theme: AppTheme.dark,

      home: const SplashScreen(),

      routes: {
        "/home": (_) =>
            const MainNavigationScreen(),

        "/login": (_) =>
            const LoginScreen(),

        "/register": (_) =>
            const RegisterScreen(),

        "/profile-onboarding": (_) =>
            const AttendeeProfileScreen(),
      },
    );
  }
}