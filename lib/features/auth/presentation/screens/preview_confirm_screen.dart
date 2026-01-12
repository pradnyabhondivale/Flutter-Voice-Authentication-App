import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreviewConfirmScreen extends StatefulWidget {
  final String username; // ✅ Changed from userId
  final String email;
  final List<Uint8List> faceImages;
  final List<Map<String, dynamic>> voiceSamples;

  const PreviewConfirmScreen({
    super.key,
    required this.username,
    required this.email,
    required this.faceImages,
    required this.voiceSamples,
  });

  @override
  State<PreviewConfirmScreen> createState() => _PreviewConfirmScreenState();
}

class _PreviewConfirmScreenState extends State<PreviewConfirmScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
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
                    'Preview & Confirm',
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple.withOpacity(0.3),
                            Colors.cyan.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fact_check_rounded,
                            color: Colors.green.shade300,
                            size: 50,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Review Your Data',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Verify all information before submitting',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Personal Information - ONLY Username and Email
                    _buildSectionCard(
                      icon: Icons.person,
                      title: 'Personal Information',
                      children: [
                        _buildInfoRow('Username', widget.username),
                        const Divider(color: Colors.white24, height: 30),
                        _buildInfoRow('Email', widget.email),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Face Images Section
                    _buildSectionCard(
                      icon: Icons.face_retouching_natural,
                      title: 'Face Images (${widget.faceImages.length})',
                      children: [
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(
                            widget.faceImages.length,
                                (index) => _buildFaceImageCard(index),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Voice Samples Section
                    _buildSectionCard(
                      icon: Icons.mic,
                      title: 'Voice Samples (${widget.voiceSamples.length})',
                      children: List.generate(
                        widget.voiceSamples.length,
                            (index) => _buildVoiceSampleCard(index),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    Container(
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.4),
                            Colors.cyan.withOpacity(0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: _isSubmitting ? null : _submitRegistration,
                          child: Center(
                            child: _isSubmitting
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check_circle, color: Colors.white, size: 26),
                                SizedBox(width: 12),
                                Text(
                                  'Submit Registration',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan.withOpacity(0.4),
                      Colors.purple.withOpacity(0.4),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaceImageCard(int index) {
    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: index == 0 ? Colors.green.withOpacity(0.5) : Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.memory(
                widget.faceImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white.withOpacity(0.5),
                      size: 40,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: index == 0
                  ? Colors.green.withOpacity(0.2)
                  : Colors.white.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.face,
                  color: index == 0 ? Colors.green : Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'Face ${index + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    color: index == 0 ? Colors.green.shade300 : Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceSampleCard(int index) {
    final sample = widget.voiceSamples[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.3),
                  Colors.purple.withOpacity(0.3),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.graphic_eq,
              color: Colors.cyan.shade300,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample ${index + 1}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sample['sentence'] ?? 'Voice recording',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle,
            color: Colors.green.shade400,
            size: 22,
          ),
        ],
      ),
    );
  }

  Future<void> _submitRegistration() async {
    setState(() => _isSubmitting = true);

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:5000/register'),
      );

      // ✅ Send only username and email
      request.fields['username'] = widget.username;
      request.fields['email'] = widget.email;

      // Add face images
      for (int i = 0; i < widget.faceImages.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
          'face_image',
          widget.faceImages[i],
          filename: 'face_$i.jpg',
        ));
      }

      // Add voice samples
      for (int i = 0; i < widget.voiceSamples.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
          'voice_sample',
          widget.voiceSamples[i]['bytes'],
          filename: 'voice_$i.wav',
        ));
        request.fields['sentence_$i'] = widget.voiceSamples[i]['sentence'];
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (mounted) {
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Registration successful!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.popUntil(context, (route) => route.isFirst);
        } else {
          final errorData = json.decode(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${errorData['error'] ?? 'Registration failed'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
