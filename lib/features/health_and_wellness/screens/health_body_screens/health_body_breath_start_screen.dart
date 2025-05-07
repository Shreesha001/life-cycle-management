import 'dart:async';
import 'package:flutter/material.dart';

class HealthBodyBreathStartScreen extends StatefulWidget {
  final double duration; // in minutes
  final String sound;

  const HealthBodyBreathStartScreen({
    super.key,
    required this.duration,
    required this.sound,
  });

  @override
  State<HealthBodyBreathStartScreen> createState() =>
      _HealthBodyBreathStartScreenState();
}

class _HealthBodyBreathStartScreenState
    extends State<HealthBodyBreathStartScreen> {
  bool isPaused = false;
  bool isInhale = true;
  int round = 1;
  late Duration sessionDuration;
  late Duration remaining;
  Timer? timer;
  Timer? breathingTimer;
  double breathSize = 100;
  final Duration inhaleDuration = const Duration(seconds: 4);
  final Duration exhaleDuration = const Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    sessionDuration = Duration(seconds: (widget.duration * 60).toInt());
    remaining = sessionDuration;
    startSession();
  }

  void startSession() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!isPaused) {
        if (remaining.inSeconds > 0) {
          setState(() {
            remaining -= const Duration(seconds: 1);
          });
        } else {
          t.cancel();
        }
      }
    });

    breathingCycle();
  }

  void breathingCycle() {
    breathingTimer?.cancel();
    breathingTimer = Timer.periodic(inhaleDuration + exhaleDuration, (timer) {
      if (!isPaused) {
        toggleBreath();
      }
    });

    if (!isPaused) {
      animateBreath(); // Start animation on resume
    }
  }

  void toggleBreath() {
    setState(() {
      isInhale = !isInhale;
    });
    animateBreath();
  }

  void animateBreath() {
    setState(() {
      breathSize = isInhale ? 160 : 100;
    });
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });

    if (isPaused) {
      breathingTimer?.cancel(); // Pause animation
    } else {
      breathingCycle(); // Resume animation
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    breathingTimer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(d.inMinutes)}:${twoDigits(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures whole screen is tappable
        onTap: togglePause,
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    Text(
                      'Round $round',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    formatDuration(remaining),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 4),
                    curve: Curves.easeInOut,
                    height: breathSize,
                    width: breathSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      isInhale ? 'Inhale' : 'Exhale',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    isPaused ? 'Paused - Tap to resume' : 'Tap screen to pause',
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
