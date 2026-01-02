import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // === PERFECT LOGO MATCHING GRADIENT ===
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.3, -0.5),  // Top-left glow like logo
            colors: [
              Color(0xFF1A0D2E),    // Deep purple (logo bg)
              Color(0xFF2A1B4D),    // Dark purple
              Color(0xFF3B2A6D),    // Mid purple
              Color(0xFF5B3FA0),    // Logo purple
              Color(0xFF8B5CF6),    // Light purple
              Color(0xFF06B6D4),    // Cyan glow
              Color(0xFF0891B2),    // Dark cyan
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.75, 0.9, 1.0],
            radius: 1.8,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Spacer for positioning
              SizedBox(height: 80),

              // === LARGER LOGO (160x160) ===
              Container(
                width: 160,   // Increased from 110
                height: 160,  // Increased from 110
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF2A1B4D), Color(0xFF1A0D2E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Color(0xFF00FFFF).withOpacity(0.6),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF00FFFF).withOpacity(0.4),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: Offset(0, 20),
                    ),
                    BoxShadow(
                      color: Color(0xFF8B5CF6).withOpacity(0.3),
                      blurRadius: 60,
                      spreadRadius: -10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/biolock_face_voice_neon.png',
                    fit: BoxFit.cover,
                    // [generated_image:281][file:299]
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Title
              Text(
                'Welcome to BioLock',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 12),

              // Subtitle
              Text(
                'Passwordless using Face & Voice Match',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Designed for secure campus attendance',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 60),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.face_retouching_natural,
                    label: 'Face\nVerify',
                    color: Color(0xFF6366F1),
                    onTap: () {},
                  ),
                  _ActionButton(
                    icon: Icons.mic,
                    label: 'Voice\nMatch',
                    color: Color(0xFF06B6D4),
                    onTap: () {},
                  ),
                  _ActionButton(
                    icon: Icons.fingerprint,
                    label: 'Zero\nTrust',
                    color: Color(0xFFEC4899),
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 40),

              // Register Button
              Container(
                width: 280,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6366F1).withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {},
                    child: Center(
                      child: Text(
                        'Register with Face & Voice',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Login Link
              TextButton(
                onPressed: () {},
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    children: [
                      TextSpan(text: 'Already registered? '),
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.4), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: color),
            SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
