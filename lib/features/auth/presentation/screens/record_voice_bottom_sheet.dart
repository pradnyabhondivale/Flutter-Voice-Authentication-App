import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class RecordVoiceBottomSheet extends StatefulWidget {
  const RecordVoiceBottomSheet({super.key});

  @override
  State<RecordVoiceBottomSheet> createState() => _RecordVoiceBottomSheetState();
}

class _RecordVoiceBottomSheetState extends State<RecordVoiceBottomSheet>
    with SingleTickerProviderStateMixin {
  bool _recording = false;
  bool _hasRecorded = false;
  String? _filePath;
  late final AnimationController _controller;
  final _record = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPerm = await _record.hasPermission();
    if (!hasPerm) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _record.start(const RecordConfig(), path: path);
    setState(() {
      _recording = true;
      _hasRecorded = false;
      _filePath = path;
    });
    _controller.repeat(reverse: true);
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    _controller.stop();
    setState(() {
      _recording = false;
      _hasRecorded = true;
    });
  }

  Future<void> _toggleRecord() async {
    if (_recording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _useRecording() async {
    if (_filePath == null) return;
    final file = File(_filePath!);
    final bytes = await file.readAsBytes();
    Navigator.pop(context, {'bytes': bytes});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.6,
      minChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF020617),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding:
            const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Record voice sample',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Say the phrase in your normal voice.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.format_quote_rounded,
                          color: Colors.white70, size: 16),
                      SizedBox(width: 8),
                      Text(
                        '“My voice is my password.”',
                        style:
                        TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final value = _controller.value;
                    final scale = 1 + 0.15 * sin(value * 2 * pi);
                    return Transform.scale(
                      scale: _recording ? scale : 1,
                      child: child,
                    );
                  },
                  child: GestureDetector(
                    onTap: _toggleRecord,
                    child: Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: _recording
                              ? [Colors.redAccent, Colors.orangeAccent]
                              : [theme.colorScheme.primary, Colors.cyan],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        _recording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _recording
                      ? 'Recording... tap to stop'
                      : (_hasRecorded
                      ? 'Recorded. You can use this sample.'
                      : 'Tap the mic to start recording.'),
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                if (_hasRecorded)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _hasRecorded = false;
                              _filePath = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white70,
                            side: const BorderSide(color: Colors.white24),
                          ),
                          child: const Text('Re-record'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _useRecording,
                          child: const Text('Use this'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
