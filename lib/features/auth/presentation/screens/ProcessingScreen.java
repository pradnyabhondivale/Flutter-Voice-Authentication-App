import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'result_screen.dart';
import '../../../core/theme/app_theme.dart';

class ProcessingScreen extends StatefulWidget {
  final String userId;
  final Uint8List faceBytes;
  final Uint8List voiceBytes;
  final String voiceSentence;

  const ProcessingScreen({
    super.key,
    required this.userId,
    required this.faceBytes,
    required this.voiceBytes,
    required this.voiceSentence,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward().then((_) {
      // Simulate backend processing
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ResultScreen(isSuccess: true),
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Processing Animation
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'Processing Biometrics',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.white70),
                children: [
                  TextSpan(text: 'Extracting facial embeddings\n'),
                  TextSpan(text: 'Analyzing voice patterns\n'),
                  TextSpan(text: 'Creating secure biometric template'),
                ],
              ),
            ),
            const Spacer(),
            // Progress Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(0, _animation.value * 3),
                _buildDot(1, (_animation.value * 3 - 1).clamp(0.0, 1.0)),
                _buildDot(2, (_animation.value * 3 - 2).clamp(0.0, 1.0)),
              ],
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index, double progress) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(progress),
      ),
    );
  }
}
