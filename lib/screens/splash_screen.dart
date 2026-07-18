import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "../services/attendee_profile_service.dart";

import "attendee_profile_screen.dart";
import "home_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  final AttendeeProfileService
      _profileService =
          AttendeeProfileService();

  @override
  void initState() {
    super.initState();

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final auth =
        context.read<AuthProvider>();

    await auth.loadUser();

    if (!mounted) return;

    /*
    |--------------------------------------------------------------------------
    | Guest User
    |--------------------------------------------------------------------------
    */

    if (!auth.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const HomeScreen(),
        ),
      );

      return;
    }

    /*
    |--------------------------------------------------------------------------
    | Logged In
    |--------------------------------------------------------------------------
    */

    final profile =
        await _profileService
            .getMyProfile(
      auth.token!,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            profile == null
                ? const AttendeeProfileScreen()
                : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.black,
      body: Center(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Text(
              "WOWYOU",
              style: TextStyle(
                fontSize: 36,
                fontWeight:
                    FontWeight.bold,
                letterSpacing: 4,
                color: Color(
                  0xFFD4AF37,
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              "Event Technology",
              style: TextStyle(
                color:
                    Colors.white70,
                letterSpacing: 2,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            const SizedBox(
              width: 28,
              height: 28,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(
                  0xFFD4AF37,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}