import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "providers/auth_provider.dart";

import "screens/splash_screen.dart";
import "screens/home_screen.dart";
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

class WowYouAttendeeApp
    extends StatelessWidget {
  const WowYouAttendeeApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    const gold =
        Color(0xFFD4AF37);

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title: "WowYou Attendee",

      theme: ThemeData(
        useMaterial3: true,

        brightness:
            Brightness.dark,

        scaffoldBackgroundColor:
            const Color(
          0xFF111111,
        ),

        colorScheme:
            ColorScheme.dark(
          primary: gold,
          secondary: gold,
          surface:
              const Color(
            0xFF181818,
          ),
        ),

        appBarTheme:
            const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor:
              Color(
            0xFF111111,
          ),
          foregroundColor:
              Colors.white,
        ),

        cardTheme:
            CardThemeData(
          color: const Color(
            0xFF1B1B1B,
          ),
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),
        ),

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                gold,
            foregroundColor:
                Colors.black,
            minimumSize:
                const Size(
              double.infinity,
              56,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
            textStyle:
                const TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        outlinedButtonTheme:
            OutlinedButtonThemeData(
          style:
              OutlinedButton.styleFrom(
            foregroundColor:
                gold,
            side:
                const BorderSide(
              color: gold,
            ),
            minimumSize:
                const Size(
              double.infinity,
              56,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
          ),
        ),

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,
          fillColor:
              const Color(
            0xFF1B1B1B,
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            borderSide:
                BorderSide.none,
          ),
          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            borderSide:
                BorderSide.none,
          ),
          focusedBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
            borderSide:
                const BorderSide(
              color: gold,
            ),
          ),
        ),

        progressIndicatorTheme:
            const ProgressIndicatorThemeData(
          color: gold,
        ),

        snackBarTheme:
            SnackBarThemeData(
          backgroundColor:
              const Color(
            0xFF1E1E1E,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          behavior:
              SnackBarBehavior
                  .floating,
        ),
      ),

      home:
          const SplashScreen(),

      routes: {
        "/home": (_) =>
            const HomeScreen(),

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