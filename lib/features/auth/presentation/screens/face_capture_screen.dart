
import 'dart:typed_data';  // For Uint8List
import 'dart:io';          // For File
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '/../core/theme/app_theme.dart';
import 'voice_sentence_screen.dart';


class FaceCaptureScreen extends StatefulWidget {
  final String userId;
  const FaceCaptureScreen({super.key, required this.userId});

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _controller;
  Future<void>? _initializeFuture;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final front = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      _controller = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
      );
      _initializeFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
    }
  }

  Future<void> _captureFace() async {
    if (_controller == null || _isCapturing) return;

    setState(() => _isCapturing = true);
    try {
      await _initializeFuture;
      final image = await _controller!.takePicture();
      final bytes = await image.readAsBytes();

      // Navigate to voice with face bytes
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VoiceSentenceScreen(
            userId: widget.userId,
            faceBytes: bytes,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $e')),
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Live Face Capture'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Camera Preview
          if (_controller != null)
            FutureBuilder<void>(
              future: _initializeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_controller!);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),

          // Face Frame Overlay
          Center(
            child: Container(
              width: 280,
              height: 320,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green.withOpacity(0.8),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          // Instructions
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Position your face\ninside the frame',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Good lighting • Look straight • No glasses/sunglasses',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Capture Button
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: GestureDetector(
                    onTap: _isCapturing ? null : _captureFace,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isCapturing
                            ? Colors.grey
                            : AppTheme.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          "https://ppl-ai-code-interpreter-files.s3.amazonaws.com/web/direct-files/1be302bfebc76848a399b413ed0a2452/224080d1-ef79-44af-9ed2-e20176cab477/2c5673b4.png",  // [image:102]
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
