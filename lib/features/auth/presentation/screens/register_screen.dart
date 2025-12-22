import 'package:flutter/material.dart';
import 'face_capture_screen.dart';
import 'voice_sentence_screen.dart';
import 'preview_confirm_screen.dart';
import '/../core/theme/app_theme.dart';
import 'dart:typed_data';
import 'dart:io';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  bool _faceCaptured = false;
  bool _voiceCaptured = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ❌ remove light background
      // backgroundColor: AppTheme.primaryColor.withOpacity(0.1),

      body: Container(
        // ✅ dark gradient background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor.withOpacity(0.18),
              AppTheme.darkBg,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // AppBar replacement (since we removed Scaffold.appBar)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text(
                  'Create Your Biometric Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your details to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),

                // User Info Form
                _buildTextField(Icons.person, 'Full Name', _nameCtrl),
                const SizedBox(height: 16),
                _buildTextField(Icons.badge, 'Student ID / Enrollment No.', _idCtrl),
                const SizedBox(height: 16),
                _buildTextField(
                  Icons.email,
                  'Email (Optional)',
                  _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 32),

                const Text(
                  'Biometric Enrollment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Face Capture Tile
                GestureDetector(
                  onTap: _faceCaptured ? null : _onCaptureFace,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _faceCaptured
                            ? Colors.green
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.face_retouching_natural,
                            color: _faceCaptured ? Colors.green : Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Live Face Capture',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _faceCaptured
                                    ? 'Face captured successfully'
                                    : 'Position face in frame for live capture',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _faceCaptured ? Icons.check_circle : Icons.arrow_forward_ios,
                          color: _faceCaptured ? Colors.green : Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Voice Capture Tile
                GestureDetector(
                  onTap: _voiceCaptured ? null : _onRecordVoice,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _voiceCaptured
                            ? Colors.green
                            : Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.mic,
                            color: _voiceCaptured ? Colors.green : Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Voice Enrollment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _voiceCaptured
                                    ? 'Voice sample recorded'
                                    : 'Speak dynamic sentence for liveness detection',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          _voiceCaptured ? Icons.check_circle : Icons.arrow_forward_ios,
                          color: _voiceCaptured ? Colors.green : Colors.white70,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 8,
                    ),
                    onPressed: _faceCaptured && _voiceCaptured ? _onRegister : null,
                    child: const Text(
                      'Complete Registration',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      IconData icon,
      String label,
      TextEditingController ctrl, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

  void _onCaptureFace() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FaceCaptureScreen(userId: _idCtrl.text),
      ),
    );
  }

  void _onRecordVoice() async {
    setState(() => _voiceCaptured = true);
  }

  void _onRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewConfirmScreen(
          userId: _idCtrl.text,
          name: _nameCtrl.text,
          email: _emailCtrl.text.isEmpty ? null : _emailCtrl.text,
          faceBytes: Uint8List(0),
          voiceBytes: Uint8List(0),
          voiceSentence: 'Test sentence',
        ),
      ),
    );
  }
}
