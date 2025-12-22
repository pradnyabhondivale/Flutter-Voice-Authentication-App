import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:untitled1/features/auth/presentation/screens/result_screen.dart';
import 'processing_screen.dart';
import '/../core/theme/app_theme.dart';
import 'dart:typed_data';  // ← FIXES Uint8List error
import 'dart:io';          // ← FIXES File error
import 'package:flutter/material.dart';
import 'processing_screen.dart';  // ← ADD THIS LINE



class PreviewConfirmScreen extends StatelessWidget {
  final String userId;
  final String? name;
  final String? email;
  final Uint8List faceBytes;
  final Uint8List voiceBytes;
  final String voiceSentence;

  const PreviewConfirmScreen({
    super.key,
    required this.userId,
    this.name,
    this.email,
    required this.faceBytes,
    required this.voiceBytes,
    required this.voiceSentence,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Confirm Enrollment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Review your biometric data',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),

            // Face Preview
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.memory(
                  faceBytes,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Voice Preview
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.mic, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    voiceSentence,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Duration: 4.2s',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Confirm Button
            // Confirm Button (BOTTOM OF preview_confirm_screen.dart)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResultScreen(isSuccess: true),  // ← SIMPLIFIED
                    ),
                  );
                },
                child: const Text(
                  '✓ Complete Registration',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
