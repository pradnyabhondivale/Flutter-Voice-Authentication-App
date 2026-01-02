import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';  // Your OnboardingScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Auto navigate after 3 seconds
    Timer(Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: Duration(milliseconds: 500),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // === YOUR NEON RING FULL BACKGROUND ===
          Image.asset(
            'assets/images/splash_bg.jpeg',  // [file:364]
            fit: BoxFit.cover,  // Perfect full screen fit
            width: double.infinity,
            height: double.infinity,
          ),

          // === DARK OVERLAY for logo visibility ===
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.8,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),

          // === CENTERED BIOLOCK LOGO ===
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo with glow
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.8), width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.6),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.4),
                        blurRadius: 60,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/biolock_logo.png',
                      fit: BoxFit.contain,  // Perfect logo fit
                      errorBuilder: (context, error, stack) => Icon(Icons.lock, size: 80, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                // BioLock Text
                Text(
                  'BioLock',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3,
                    shadows: [
                      Shadow(color: Colors.black87, blurRadius: 10, offset: Offset(2, 2)),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Face + Voice Authentication',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
