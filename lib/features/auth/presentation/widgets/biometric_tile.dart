import 'package:flutter/material.dart';

class BiometricTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String status;
  final bool isDone;
  final VoidCallback onTap;

  const BiometricTile({
    super.key,
    required this.icon,
    required this.title,
    required this.status,
    required this.isDone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDone ? Colors.greenAccent : Colors.white60;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.06),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isDone ? Icons.check_circle_rounded : Icons.chevron_right_rounded,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
