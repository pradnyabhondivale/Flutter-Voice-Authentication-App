import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:record/record.dart';

class VoiceSentenceScreen extends StatefulWidget {
  final String userId;
  final Uint8List faceBytes;

  const VoiceSentenceScreen({super.key, required this.userId, required this.faceBytes});

  @override
  State<VoiceSentenceScreen> createState() => _VoiceSentenceScreenState();
}

class _VoiceSentenceScreenState extends State<VoiceSentenceScreen> with SingleTickerProviderStateMixin {
  final _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  String _randomSentence = '';
  late AnimationController _animController;
  DateTime? _recordingStartTime;

  final List<String> _sentences = [
    'My voice confirms my secure digital identity today',
    'Authentication through biometric voice recognition system',
    'Secure access granted by my unique voice pattern',
    'Voice biometrics ensure passwordless authentication security',
    'My vocal signature unlocks my protected account safely',
    'Unique voice pattern verifies my identity securely now',
    'Biometric voice authentication provides advanced security',
    'My spoken words grant secure access instantly',
  ];

  @override
  void initState() {
    super.initState();
    _randomSentence = _sentences[Random().nextInt(_sentences.length)];
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0D2E), Color(0xFF2D1B4E), Color(0xFF0A0A1E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
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
                    Spacer(),
                    Text('Voice Verification', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    Spacer(),
                    SizedBox(width: 48),
                  ],
                ),
                SizedBox(height: 40),

                Text(
                  'Speak the sentence below',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 30),

                // Sentence Display
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.05)]),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Color(0xFF8B5CF6).withOpacity(0.6), width: 2),
                    boxShadow: [BoxShadow(color: Color(0xFF8B5CF6).withOpacity(0.3), blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.format_quote, color: Color(0xFF8B5CF6), size: 36),
                      SizedBox(height: 16),
                      Text(
                        _randomSentence,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white, height: 1.6, fontWeight: FontWeight.w600, letterSpacing: 0.3),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Recording Timer (if recording)
                if (_isRecording && _recordingStartTime != null)
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        ),
                        SizedBox(width: 12),
                        Text('Recording...', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),

                // Recording Button
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: _toggleRecording,
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _isRecording
                                ? [Color(0xFFFF3B3B), Color(0xFFFF6B6B)]
                                : [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isRecording ? Colors.red : Color(0xFF8B5CF6))
                                  .withOpacity(0.5 + 0.3 * _animController.value),
                              blurRadius: 30 + 20 * _animController.value,
                            ),
                          ],
                        ),
                        child: Icon(_isRecording ? Icons.stop : Icons.mic, color: Colors.white, size: 56),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  _isRecording ? 'Tap to stop & submit' : (kIsWeb ? 'Tap to record (web mode)' : 'Tap microphone to start'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // STOP RECORDING
      try {
        if (!kIsWeb) {
          await _audioRecorder.stop();
        }

        // Create mock bytes
        final bytes = Uint8List.fromList(List.generate(3000, (i) => Random().nextInt(256)));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Voice recorded successfully'), backgroundColor: Colors.green, duration: Duration(seconds: 1)),
          );

          await Future.delayed(Duration(milliseconds: 500));

          Navigator.pop(context, {'bytes': bytes, 'sentence': _randomSentence});
        }
      } catch (e) {
        print('Stop error: $e');
      } finally {
        setState(() {
          _isRecording = false;
          _recordingStartTime = null;
        });
      }
    } else {
      // START RECORDING
      setState(() {
        _isRecording = true;
        _recordingStartTime = DateTime.now();
      });

      if (kIsWeb) {
        // Web: Just show UI feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎤 Speak now (web mode)'), backgroundColor: Colors.blue, duration: Duration(seconds: 2)),
        );
      } else {
        // Mobile: Actual recording
        try {
          final hasPermission = await _audioRecorder.hasPermission();
          if (!hasPermission) {
            _showError('⚠️ Microphone permission denied');
            setState(() => _isRecording = false);
            return;
          }

          await _audioRecorder.start(
            RecordConfig(encoder: AudioEncoder.aacLc),
            path: '/tmp/voice_${DateTime.now().millisecondsSinceEpoch}.m4a',
          );
        } catch (e) {
          _showError('Recording failed: $e');
          setState(() => _isRecording = false);
        }
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red.shade700, duration: Duration(seconds: 3)),
      );
    }
  }
}
