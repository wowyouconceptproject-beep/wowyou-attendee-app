import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "providers/auth_provider.dart";

import "screens/splash_screen.dart";
import "screens/main_navigation_screen.dart";
import "screens/login_screen.dart";
import "screens/register_screen.dart";
import "screens/attendee_profile_screen.dart";

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
    const wowBlue = Color(0xFF3E86A4);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: "WowYou Attendee",

      theme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(
          0xFF050505,
        ),

        colorScheme: ColorScheme.dark(
          primary: wowBlue,
          secondary: wowBlue,
          surface: const Color(
            0xFF0B0B0B,
          ),
        ),

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Color(
            0xFF050505,
          ),
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),

        cardTheme: CardThemeData(
          color: const Color(
            0xFF121212,
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              24,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: wowBlue,
            foregroundColor: Colors.black,
            minimumSize: const Size(
              double.infinity,
              56,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: wowBlue,
            side: const BorderSide(
              color: wowBlue,
            ),
            minimumSize: const Size(
              double.infinity,
              56,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                16,
              ),
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(
            0xFF121212,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              16,
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              16,
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              16,
            ),
            borderSide: const BorderSide(
              color: wowBlue,
            ),
          ),
        ),

        progressIndicatorTheme:
            const ProgressIndicatorThemeData(
          color: wowBlue,
        ),

        snackBarTheme: SnackBarThemeData(
          backgroundColor: const Color(
            0xFF121212,
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              14,
            ),
          ),
        ),
      ),

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