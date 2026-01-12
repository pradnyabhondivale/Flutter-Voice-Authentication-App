import 'dart:typed_data';
import 'package:flutter/material.dart';

class FaceCaptureScreen extends StatefulWidget {
  final String userId;

  const FaceCaptureScreen({super.key, required this.userId});

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Camera not supported on this platform'),
      ),
    );
  }
}
