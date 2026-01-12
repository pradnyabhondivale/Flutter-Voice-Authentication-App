import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'face_capture_screen.dart';
import 'voice_sentence_screen.dart';

class BiometricSelectionScreen extends StatefulWidget {
  final String userId;

  const BiometricSelectionScreen({super.key, required this.userId});

  @override
  State<BiometricSelectionScreen> createState() => _BiometricSelectionScreenState();
}

class _BiometricSelectionScreenState extends State<BiometricSelectionScreen> {
  bool _faceCompleted = false;
  bool _voiceCompleted = false;
  Uint8List? _faceBytes;
  Uint8List? _voiceBytes;
  String? _voiceSentence;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A1E),
              Color(0xFF1A0D2E),
              Color(0xFF2D1B4E),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'Biometric Verification',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 40),

                // Title
                Text(
                  'Complete Both Steps',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 12),
                Text(
                  'Face and voice verification required',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7)),
                ),
                SizedBox(height: 50),

                // Face Capture Button
                _buildBiometricCard(
                  title: 'Face Verification',
                  subtitle: 'Capture your live face',
                  icon: Icons.face_retouching_natural,
                  gradient: [Color(0xFF00D4FF), Color(0xFF0099CC)],
                  isCompleted: _faceCompleted,
                  onTap: () => _captureFace(),
                ),
                SizedBox(height: 20),

                // Voice Capture Button
                _buildBiometricCard(
                  title: 'Voice Verification',
                  subtitle: 'Speak the random sentence',
                  icon: Icons.mic,
                  gradient: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                  isCompleted: _voiceCompleted,
                  onTap: () => _captureVoice(),
                ),

                Spacer(),

                // Submit Button
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (_faceCompleted && _voiceCompleted)
                          ? [Color(0xFF00D4FF), Color(0xFF8B5CF6)]
                          : [Colors.grey.shade700, Colors.grey.shade800],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: (_faceCompleted && _voiceCompleted)
                        ? [
                      BoxShadow(
                        color: Color(0xFF00D4FF).withOpacity(0.4),
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ]
                        : [],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: (_faceCompleted && _voiceCompleted) ? _submitBiometrics : null,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
                            SizedBox(width: 12),
                            Text(
                              'Submit Authentication',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient.map((c) => c.withOpacity(0.2)).toList()),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: gradient[0].withOpacity(0.5), blurRadius: 20),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                      SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.7))),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    child: Icon(Icons.check, color: Colors.white, size: 20),
                  )
                else
                  Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.5), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureFace() async {
    final result = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => FaceCaptureScreen(userId: widget.userId)),
    );

    if (result != null && result['bytes'] != null) {
      setState(() {
        _faceBytes = result['bytes'] as Uint8List;
        _faceCompleted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Face captured successfully'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _captureVoice() async {
    if (!_faceCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Please complete face capture first'), backgroundColor: Colors.orange),
      );
      return;
    }

    final result = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => VoiceSentenceScreen(userId: widget.userId, faceBytes: _faceBytes!)),
    );

    if (result != null && result['bytes'] != null && result['sentence'] != null) {
      setState(() {
        _voiceBytes = result['bytes'] as Uint8List;
        _voiceSentence = result['sentence'] as String;
        _voiceCompleted = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Voice captured successfully'), backgroundColor: Colors.green),
      );
    }
  }

  void _submitBiometrics() {
    Navigator.pop(context, {
      'faceBytes': _faceBytes,
      'voiceBytes': _voiceBytes,
      'sentence': _voiceSentence,
    });
  }
}
