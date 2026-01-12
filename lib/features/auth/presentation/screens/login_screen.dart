import 'dart:typed_data';
import 'package:flutter/material.dart';
import '/../../core/theme/app_theme.dart';
import 'face_capture_screen.dart';
import 'voice_sentence_screen.dart';
import 'biometric_selection_screen.dart';  // ✅ ADD THIS
import 'package:video_player/video_player.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late VideoPlayerController _videoController;
  final _idCtrl = TextEditingController();
  bool _isBiometricFlowRunning = false;
  Uint8List? _faceBytes;
  Uint8List? _voiceBytes;
  String? _voiceSentence;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/videos/login_bg.mp4')
      ..initialize().then((_) {
        setState(() {});
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    _videoController.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Background
          _videoController.value.isInitialized
              ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            ),
          )
              : Container(color: Colors.black),

          // Dark overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Glass top bar
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10)),
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                            child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Login', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 1)),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Glass title card
                  Container(
                    padding: EdgeInsets.all(24),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: Offset(0, 15)),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text('Login with Face & Voice', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.2)),
                        SizedBox(height: 8),
                        Text('Enter your ID and authenticate using live biometrics', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.85), letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Glass ID input
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15)],
                    ),
                    child: TextField(
                      controller: _idCtrl,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      decoration: InputDecoration(
                        labelText: 'User ID / Email',
                        prefixIcon: Icon(Icons.badge_outlined, color: Colors.white70),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        labelStyle: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Glass info card
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.cyan.withOpacity(0.3), Colors.purple.withOpacity(0.3)]),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.lock_person_rounded, color: Colors.white, size: 24),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Live face scan + dynamic voice sentence verification\nZero-knowledge passwordless authentication',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Main LOGIN BUTTON
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.cyan.withOpacity(0.3), Colors.purple.withOpacity(0.3)]),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                      boxShadow: [
                        BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 25, offset: Offset(0, 12)),
                        BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: _isBiometricFlowRunning ? null : () => _onBiometricLogin(),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_isBiometricFlowRunning ? Icons.hourglass_empty : Icons.face_retouching_natural_rounded, color: Colors.white, size: 24),
                              SizedBox(width: 12),
                              Text(
                                _isBiometricFlowRunning ? 'Authenticating...' : 'Login with Face & Voice',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Glass disclaimer
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Text(
                      'Both live face & voice must match your registered profile',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ CORRECTED BIOMETRIC LOGIN FUNCTION
  Future<void> _onBiometricLogin() async {
    final userId = _idCtrl.text.trim();
    if (userId.isEmpty) {
      _showSnack('⚠️ Please enter your User ID or email');
      return;
    }

    setState(() => _isBiometricFlowRunning = true);

    try {
      // Navigate to BiometricSelectionScreen
      final result = await Navigator.push<Map<String, dynamic>?>(
        context,
        MaterialPageRoute(builder: (_) => BiometricSelectionScreen(userId: userId)),
      );

      if (result != null) {
        _faceBytes = result['faceBytes'] as Uint8List?;
        _voiceBytes = result['voiceBytes'] as Uint8List?;
        _voiceSentence = result['sentence'] as String?;

        _showSnack('✅ Authentication complete! Verifying...');
        // TODO: Send to backend for verification
      } else {
        _showSnack('❌ Biometric capture cancelled');
      }
    } catch (e) {
      _showSnack('❌ Biometric login failed: $e');
    } finally {
      if (mounted) setState(() => _isBiometricFlowRunning = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }
}
