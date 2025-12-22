import 'dart:typed_data';
import 'package:flutter/material.dart';
import '/../../core/theme/app_theme.dart';
import 'face_capture_screen.dart';
import 'voice_sentence_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _idCtrl = TextEditingController();     // user id / enrollment / email
  bool _isBiometricFlowRunning = false;
  Uint8List? _faceBytes;
  Uint8List? _voiceBytes;
  String? _voiceSentence;

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.2),
              AppTheme.darkBg,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top bar
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                const Text(
                  'Login with Face & Voice',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your ID and authenticate using your live face and voice.\nNo passwords needed.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),

                // ID / Email field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _idCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'User ID / Email',
                      prefixIcon: Icon(Icons.badge, color: Colors.white70),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Info card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.lock_person_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'We will capture a fresh face image and a dynamic voice sentence to verify your identity.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Main biometric login button
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 8,
                    ),
                    onPressed: _isBiometricFlowRunning ? null : _onBiometricLogin,
                    icon: const Icon(Icons.face_retouching_natural_rounded),
                    label: _isBiometricFlowRunning
                        ? const Text(
                      'Authenticating...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                        : const Text(
                      'Login with Face & Voice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Explanation
                const Center(
                  child: Text(
                    'Both face and voice must match your registered profile.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onBiometricLogin() async {
    final userId = _idCtrl.text.trim();
    if (userId.isEmpty) {
      _showSnack('Please enter your User ID or email first.');
      return;
    }

    setState(() => _isBiometricFlowRunning = true);

    try {
      // 1) Capture face
      final faceResult = await Navigator.push<Map<String, dynamic>?>(
        context,
        MaterialPageRoute(
          builder: (_) => FaceCaptureScreen(userId: userId),
        ),
      );

      if (faceResult == null || faceResult['bytes'] == null) {
        _showSnack('Face capture cancelled.');
        setState(() => _isBiometricFlowRunning = false);
        return;
      }
      _faceBytes = faceResult['bytes'] as Uint8List;

      // 2) Capture voice with dynamic sentence
      final voiceResult = await Navigator.push<Map<String, dynamic>?>(
        context,
        MaterialPageRoute(
          builder: (_) => VoiceSentenceScreen(
            userId: userId,
            faceBytes: _faceBytes!,
          ),
        ),
      );

      if (voiceResult == null ||
          voiceResult['bytes'] == null ||
          voiceResult['sentence'] == null) {
        _showSnack('Voice capture cancelled.');
        setState(() => _isBiometricFlowRunning = false);
        return;
      }

      _voiceBytes = voiceResult['bytes'] as Uint8List;
      _voiceSentence = voiceResult['sentence'] as String;


      // 3) TODO: send to backend for login verification
      // Example:
      // await authApi.loginWithBiometrics(
      //   userId: userId,
      //   faceBytes: _faceBytes!,
      //   voiceBytes: _voiceBytes!,
      //   sentence: _voiceSentence!,
      // );

      _showSnack('Biometric data captured. Ready to send to backend.');

    } catch (e) {
      _showSnack('Biometric login failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isBiometricFlowRunning = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
