import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '/../core/theme/app_theme.dart';
import 'preview_confirm_screen.dart';
import 'dart:io';



class VoiceSentenceScreen extends StatefulWidget {
  final String userId;
  final Uint8List faceBytes;

  const VoiceSentenceScreen({
    super.key,
    required this.userId,
    required this.faceBytes,
  });

  @override
  State<VoiceSentenceScreen> createState() => _VoiceSentenceScreenState();
}

class _VoiceSentenceScreenState extends State<VoiceSentenceScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasRecorded = false;
  Uint8List? _voiceBytes;
  late AnimationController _pulseController;
  String _sentence = '';

  // Dynamic sentences for replay attack prevention
  final List<String> _sentences = [
    'My voice confirms my secure login at twelve thirty',
    'The quick brown fox authenticates securely today',
    'Voice verification completes at three forty five',
    'Secure biometric login established successfully',
    'Authentication voice sample recorded at eleven twenty',
  ];

  @override
  void initState() {
    super.initState();
    _generateSentence();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _generateSentence() {
    setState(() {
      _sentence = _sentences[Random().nextInt(_sentences.length)];
    });
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    final status = await _recorder.hasPermission();
    if (status != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission required')),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(),
      path: path,
    );

    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    if (path != null) {
      final bytes = await File(path).readAsBytes();
      setState(() {
        _voiceBytes = bytes;
        _isRecording = false;
        _hasRecorded = true;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Voice Enrollment'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Speak the sentence shown below',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            // Dynamic Sentence Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.format_quote, color: Colors.white70, size: 32),
                  const SizedBox(height: 16),
                  Text(
                    _sentence,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Icon(Icons.format_quote, color: Colors.white70, size: 32),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Record Button with Pulse Animation
            GestureDetector(
              onTap: _toggleRecording,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRecording ? 1.1 : 1.0,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _isRecording
                              ? [Colors.red, Colors.orange]
                              : [AppTheme.primaryColor, AppTheme.secondaryColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording ? Colors.red : AppTheme.primaryColor)
                                .withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isRecording
                  ? 'Recording... Tap to stop'
                  : _hasRecorded
                  ? 'Voice recorded successfully!'
                  : 'Tap microphone to start',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),

            // Next Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                onPressed: _hasRecorded ? _goToPreview : null,
                child: const Text(
                  'Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _goToPreview() {
    if (_voiceBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please record your voice first.')),
      );
      return;
    }

    // For LOGIN: return bytes + sentence to previous screen
    Navigator.pop(context, {
      'bytes': _voiceBytes!,
      'sentence': _sentence,
    });
  }

}
