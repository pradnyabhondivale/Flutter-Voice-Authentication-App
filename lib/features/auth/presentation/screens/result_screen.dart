import 'package:flutter/material.dart';
import '/../core/theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  final bool isSuccess;
  const ResultScreen({super.key, required this.isSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isSuccess ? Colors.green : Colors.red.withOpacity(0.1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Result Icon
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
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
              const SizedBox(height: 32),

              // Result Title
              Text(
                isSuccess ? 'Registration Successful!' : 'Registration Failed',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              // Result Message
              Text(
                isSuccess
                    ? 'Your biometric profile has been created securely.\nYou can now login using face + voice.'
                    : 'Please try again with better lighting and clear voice.\nCheck your internet connection.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const Spacer(),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: isSuccess ? AppTheme.primaryColor : Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 8,
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Text(
                    isSuccess ? 'Login Now' : 'Try Again',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
