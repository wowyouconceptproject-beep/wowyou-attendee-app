import "dart:async";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../providers/auth_provider.dart";
import "../services/attendee_profile_service.dart";

import "attendee_profile_screen.dart";
import "main_navigation_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final AttendeeProfileService _profileService =
      AttendeeProfileService();

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  String _status = "Preparing your experience...";

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(
      begin: 0.45,
      end: 1,
    ).animate(_controller);

    _bootstrap();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    final auth = context.read<AuthProvider>();

    setState(() {
      _status = "Checking your account...";
    });

    await auth.loadUser();

    if (!mounted) return;

    if (!auth.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(),
        ),
      );
      return;
    }

    setState(() {
      _status = "Loading your profile...";
    });

    final profile =
        await _profileService.getMyProfile(auth.token!);

    if (!mounted) return;

    setState(() {
      _status = "Almost ready...";
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => profile == null
            ? const AttendeeProfileScreen()
            : const MainNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Column(
            children: [
              const Spacer(),

              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (_, __) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [
                            Color(0x33D4AF37),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              const Text(
                "WOWYOU",
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "EVENT TECHNOLOGY",
                style: TextStyle(
                  color: Colors.white.withOpacity(.55),
                  letterSpacing: 5,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                "Where Events Connect\nPeople & Possibilities",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: Color(0x22FFFFFF),
                  valueColor:
                      AlwaysStoppedAnimation(
                    Color(0xFFD4AF37),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              AnimatedSwitcher(
                duration:
                    const Duration(milliseconds: 300),
                child: Text(
                  _status,
                  key: ValueKey(_status),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}