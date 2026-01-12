import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:camera/camera.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class FaceCaptureScreen extends StatefulWidget {
  final String userId;
  final bool isRegistration;

  const FaceCaptureScreen({
    super.key,
    required this.userId,
    this.isRegistration = false,
  });

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  CameraController? _cameraController;
  html.MediaStream? _webStream;
  html.VideoElement? _webVideoElement;
  String? _webViewId;

  bool _cameraReady = false;
  bool _isCapturing = false;
  String _errorMessage = '';

  int _currentPoseIndex = 0;
  List<Uint8List> _capturedImages = []; // Store all captured images

  final List<Map<String, dynamic>> _registrationPoses = [
    {
      'title': 'Front Face',
      'icon': Icons.face,
      'instructions': 'Look straight • Neutral expression',
      'color': Color(0xFF00D4FF),
    },
    {
      'title': 'Slight Left',
      'icon': Icons.arrow_back,
      'instructions': 'Turn head slightly left',
      'color': Color(0xFF10B981),
    },
    {
      'title': 'Slight Right',
      'icon': Icons.arrow_forward,
      'instructions': 'Turn head slightly right',
      'color': Color(0xFF8B5CF6),
    },
    {
      'title': 'Smile',
      'icon': Icons.sentiment_satisfied_alt,
      'instructions': 'Natural smile',
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'Serious',
      'icon': Icons.sentiment_neutral,
      'instructions': 'Neutral face • No smile',
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initWebCamera();
    } else {
      _initMobileCamera();
    }
  }

  Future<void> _initWebCamera() async {
    try {
      _webViewId = 'camera-view-${DateTime.now().millisecondsSinceEpoch}';

      _webVideoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..setAttribute('playsinline', 'true')
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..style.transform = 'scaleX(-1)';

      ui_web.platformViewRegistry.registerViewFactory(
        _webViewId!,
            (int viewId) => _webVideoElement!,
      );

      final constraints = {
        'video': {
          'facingMode': 'user',
          'width': {'ideal': 1280},
          'height': {'ideal': 720}
        },
        'audio': false
      };

      _webStream = await html.window.navigator.mediaDevices!.getUserMedia(constraints);
      _webVideoElement!.srcObject = _webStream;

      await _webVideoElement!.onLoadedMetadata.first;

      if (mounted) {
        setState(() {
          _cameraReady = true;
          _errorMessage = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Camera access denied. Please allow camera permission.';
          _cameraReady = false;
        });
      }
    }
  }

  Future<void> _initMobileCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'No camera found');
        return;
      }

      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _cameraReady = true;
          _errorMessage = '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Camera initialization failed';
          _cameraReady = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _webStream?.getTracks().forEach((track) => track.stop());
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_cameraReady)
            Positioned.fill(
              child: kIsWeb ? _buildWebCameraPreview() : _buildMobileCameraPreview(),
            )
          else if (_errorMessage.isNotEmpty)
            _buildErrorView()
          else
            _buildLoadingView(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 10),
                if (_cameraReady)
                  widget.isRegistration
                      ? _buildRegistrationInstructions()
                      : _buildLoginInstructions(),
                Spacer(),
                if (_cameraReady) _buildCaptureButton(),
                SizedBox(height: 50),
              ],
            ),
          ),

          if (_cameraReady)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.25,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 300,
                  height: 380,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: widget.isRegistration
                          ? _registrationPoses[_currentPoseIndex]['color']
                          : Color(0xFF00D4FF),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(190),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWebCameraPreview() {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00D4FF).withOpacity(0.3),
                blurRadius: 30,
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: HtmlElementView(viewType: _webViewId!),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCameraPreview() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Container();
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _cameraController!.value.aspectRatio,
        child: CameraPreview(_cameraController!),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF00D4FF), strokeWidth: 3),
          SizedBox(height: 20),
          Text('Starting camera...', style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Please allow camera access when prompted',
              style: TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 80),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(_errorMessage, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _errorMessage = '';
                _cameraReady = false;
              });
              if (kIsWeb) {
                _initWebCamera();
              } else {
                _initMobileCamera();
              }
            },
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00D4FF),
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.isRegistration
                  ? 'Registration ${_currentPoseIndex + 1}/5'
                  : 'Face Capture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Spacer(),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildLoginInstructions() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF00D4FF).withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.face_retouching_natural, color: Color(0xFF00D4FF), size: 20),
              SizedBox(width: 8),
              Text('Position Your Face', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Good lighting • Look straight • No glasses',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationInstructions() {
    final currentPose = _registrationPoses[_currentPoseIndex];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3),
              width: index == _currentPoseIndex ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index <= _currentPoseIndex
                    ? currentPose['color']
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        SizedBox(height: 12),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.85),
                Colors.black.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: currentPose['color'].withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: currentPose['color'].withOpacity(0.3),
                blurRadius: 15,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: currentPose['color'].withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  currentPose['icon'],
                  color: currentPose['color'],
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentPose['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    currentPose['instructions'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureButton() {
    final currentPose = widget.isRegistration
        ? _registrationPoses[_currentPoseIndex]
        : {'color': Color(0xFF00D4FF)};

    return Column(
      children: [
        GestureDetector(
          onTap: _isCapturing ? null : _captureImage,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _isCapturing
                    ? [Colors.grey.shade600, Colors.grey.shade700]
                    : [currentPose['color'], currentPose['color'].withOpacity(0.7)],
              ),
              boxShadow: !_isCapturing
                  ? [
                BoxShadow(
                  color: currentPose['color'].withOpacity(0.6),
                  blurRadius: 25,
                  spreadRadius: 2,
                )
              ]
                  : [],
            ),
            child: _isCapturing
                ? Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : Icon(Icons.camera_alt, color: Colors.white, size: 36),
          ),
        ),
        SizedBox(height: 12),
        Text(
          _isCapturing ? 'Capturing...' : 'Tap to Capture',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            shadows: [Shadow(color: Colors.black.withOpacity(0.8), blurRadius: 8)],
          ),
        ),
      ],
    );
  }

  Future<void> _captureImage() async {
    if (!_cameraReady) return;

    setState(() => _isCapturing = true);

    try {
      Uint8List bytes;

      if (kIsWeb) {
        if (_webVideoElement == null) throw Exception('Video element not initialized');

        final canvas = html.CanvasElement(
          width: _webVideoElement!.videoWidth,
          height: _webVideoElement!.videoHeight,
        );

        final ctx = canvas.context2D;
        ctx.translate(canvas.width!, 0);
        ctx.scale(-1, 1);
        ctx.drawImageScaled(_webVideoElement!, 0, 0, canvas.width!, canvas.height!);

        final dataUrl = canvas.toDataUrl('image/jpeg', 0.9);
        bytes = Uri.parse(dataUrl).data!.contentAsBytes();
      } else {
        if (_cameraController == null || !_cameraController!.value.isInitialized) {
          throw Exception('Camera not ready');
        }

        final image = await _cameraController!.takePicture();
        bytes = await image.readAsBytes();
      }

      if (mounted) {
        if (widget.isRegistration && _currentPoseIndex < 4) {
          // Store captured image
          _capturedImages.add(bytes);

          setState(() {
            _currentPoseIndex++;
            _isCapturing = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Pose ${_currentPoseIndex}/5 captured!'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 800),
            ),
          );
        } else {
          // Last pose or login
          if (widget.isRegistration) {
            _capturedImages.add(bytes); // Add last image

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ All 5 poses captured successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );

            await Future.delayed(Duration(milliseconds: 800));

            // ✅ Return ALL 5 captured images
            Navigator.pop(context, {'allImages': _capturedImages});
          } else {
            // Login - single image
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Face captured successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(milliseconds: 800),
              ),
            );

            await Future.delayed(Duration(milliseconds: 500));
            Navigator.pop(context, {'bytes': bytes});
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Capture failed: $e'),
            backgroundColor: Colors.red.shade700,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted && !widget.isRegistration) {
        setState(() => _isCapturing = false);
      }
    }
  }
}
