import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'face_capture_screen.dart';
import 'voice_sentence_screen.dart';
import 'preview_confirm_screen.dart';
import '/../core/theme/app_theme.dart';
import 'dart:typed_data';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameCtrl = TextEditingController(); // ✅ Changed to username
  final _emailCtrl = TextEditingController();

  late VideoPlayerController _videoController;

  List<Uint8List> _faceImages = [];
  List<Map<String, dynamic>> _voiceSamples = [];

  final int _requiredFaceCount = 5;
  final int _requiredVoiceCount = 3;

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
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faceProgress = _faceImages.length / _requiredFaceCount;
    final voiceProgress = _voiceSamples.length / _requiredVoiceCount;
    final allCaptured = _faceImages.length >= _requiredFaceCount &&
        _voiceSamples.length >= _requiredVoiceCount;

    return Scaffold(
      body: Stack(
        children: [
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
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyan.withOpacity(0.3),
                                Colors.purple.withOpacity(0.3),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.security, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Biometric Profile',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Multiple samples ensure better accuracy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.85),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ✅ Only Username and Email fields
                  _buildTextField(Icons.person_outline, 'Username', _usernameCtrl),
                  const SizedBox(height: 14),
                  _buildTextField(
                    Icons.email_outlined,
                    'Email',
                    _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyan.withOpacity(0.3),
                                Colors.purple.withOpacity(0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.security, color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          'Biometric Enrollment',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  _buildCaptureSection(
                    icon: Icons.face_retouching_natural,
                    title: 'Face Images',
                    subtitle: _faceImages.isEmpty
                        ? 'Capture 5 poses in one session'
                        : '${_faceImages.length}/$_requiredFaceCount captured',
                    progress: faceProgress,
                    isComplete: _faceImages.length >= _requiredFaceCount,
                    onTap: _faceImages.length >= _requiredFaceCount ? null : _onCaptureFace,
                    sampleCount: _faceImages.length,
                  ),
                  const SizedBox(height: 14),

                  _buildCaptureSection(
                    icon: Icons.mic,
                    title: 'Voice Samples',
                    subtitle: '${_voiceSamples.length}/$_requiredVoiceCount recorded',
                    progress: voiceProgress,
                    isComplete: _voiceSamples.length >= _requiredVoiceCount,
                    onTap: _voiceSamples.length < _requiredVoiceCount ? _onRecordVoice : null,
                    sampleCount: _voiceSamples.length,
                  ),
                  const SizedBox(height: 32),

                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                      gradient: allCaptured
                          ? LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.3),
                          Colors.purple.withOpacity(0.3),
                        ],
                      )
                          : LinearGradient(
                        colors: [
                          Colors.grey.withOpacity(0.2),
                          Colors.grey.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.4)),
                      boxShadow: allCaptured
                          ? [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.4),
                          blurRadius: 25,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                        ),
                      ]
                          : [],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(32),
                        onTap: allCaptured ? _onRegister : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                allCaptured ? Icons.check_circle_rounded : Icons.hourglass_empty,
                                color: allCaptured ? Colors.white : Colors.grey.shade600,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                allCaptured
                                    ? 'Complete Registration'
                                    : 'Capture All Biometric Data',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: allCaptured ? Colors.white : Colors.grey.shade600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  if (!allCaptured)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.amber.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.amber.shade300, size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Capture all 5 face poses in one camera session',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String label, TextEditingController ctrl, {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15),
        ],
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          labelStyle: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildCaptureSection({
    required IconData icon,
    required String title,
    required String subtitle,
    required double progress,
    required bool isComplete,
    required VoidCallback? onTap,
    required int sampleCount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isComplete ? Colors.green.withOpacity(0.5) : Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isComplete
                          ? [Colors.green.withOpacity(0.4), Colors.green.withOpacity(0.6)]
                          : [Colors.cyan.withOpacity(0.3), Colors.purple.withOpacity(0.3)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isComplete ? Colors.green.shade300 : Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isComplete ? Icons.check_circle_rounded : Icons.add_circle_outline_rounded,
                  color: isComplete ? Colors.green.shade300 : Colors.white70,
                  size: 28,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isComplete ? Colors.green : Colors.cyan,
              ),
              minHeight: 8,
            ),
          ),
          if (sampleCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isComplete
                    ? Colors.green.withOpacity(0.2)
                    : Colors.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isComplete
                      ? Colors.green.withOpacity(0.4)
                      : Colors.cyan.withOpacity(0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isComplete ? Icons.check_circle : Icons.pending,
                    color: isComplete ? Colors.green : Colors.cyan,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$sampleCount samples captured',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onCaptureFace() async {
    if (_usernameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please enter Username first'), backgroundColor: Colors.red),
      );
      return;
    }

    if (_faceImages.length >= _requiredFaceCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ You already have 5 face images!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FaceCaptureScreen(
          userId: _usernameCtrl.text,
          isRegistration: true,
        ),
      ),
    );

    if (result != null && result['allImages'] != null) {
      final allImages = result['allImages'] as List<Uint8List>;

      setState(() {
        _faceImages = allImages;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ All ${_faceImages.length} face poses captured successfully!'),
          backgroundColor: const Color(0xFF10B981),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onRecordVoice() async {
    if (_usernameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please enter Username first'), backgroundColor: Colors.red),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceSentenceScreen(
          userId: _usernameCtrl.text,
          faceBytes: _faceImages.isNotEmpty ? _faceImages.first : Uint8List(0),
        ),
      ),
    );

    if (result != null && result['bytes'] != null) {
      setState(() => _voiceSamples.add({
        'bytes': result['bytes'] as Uint8List,
        'sentence': result['sentence'] as String,
      }));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Voice sample ${_voiceSamples.length}/$_requiredVoiceCount recorded!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _onRegister() {
    if (_usernameCtrl.text.isEmpty || _emailCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Please fill in all required fields'), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PreviewConfirmScreen(
          username: _usernameCtrl.text,  // ✅ Only username
          email: _emailCtrl.text,         // ✅ Only email
          faceImages: _faceImages,
          voiceSamples: _voiceSamples,
        ),
      ),
    );
  }

}
