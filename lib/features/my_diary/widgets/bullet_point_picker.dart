import 'package:flutter/material.dart';

class BulletPointPicker {
  static Future<String?> show({
    required BuildContext context,
    String currentBullet = '⭐',
  }) async {
    final List<String> bullets = ['', '⭐', '•', '➡️', '✔️', '✳️', '🔸', '🔹'];

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E2A47),
          title: const Text(
            'Select a bullet point style',
            style: TextStyle(color: Colors.white),
          ),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                bullets.map((symbol) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(symbol);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            symbol == currentBullet
                                ? Colors.purple.shade200
                                : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(symbol, style: const TextStyle(fontSize: 24)),
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}
