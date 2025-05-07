import 'package:flutter/material.dart';

class SleepCycleProgramScreen extends StatelessWidget {
  const SleepCycleProgramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03192E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Programs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: const [
                    ProgramCard(
                      title: "Sleep Coaching with Dr. Mike",
                      subtitle:
                          "Overcome sleep challenges at every stage in life with proven tips.",
                      imagePath: "assets/period_dates/image/meditation.jpg",
                      bgColor: Color(0xFF1B2C3B),
                    ),
                    ProgramCard(
                      title: "Relax from stress",
                      subtitle: "Physical exercises to help you fall asleep.",
                      imagePath: "assets/period_dates/image/meditation.jpg",
                      bgColor: Color(0xFF007FA5),
                    ),
                    ProgramCard(
                      title: "Daytime hacks",
                      subtitle:
                          "Things to do when you're awake, to help you sleep at night.",
                      imagePath: "assets/period_dates/image/meditation.jpg",
                      bgColor: Color(0xFF7D3F6A),
                    ),
                    ProgramCard(
                      title: "Relax the mind",
                      subtitle:
                          "Simple, cognitive exercises to help you fall asleep.",
                      imagePath: "assets/period_dates/image/meditation.jpg",
                      bgColor: Color(0xFFE68900),
                    ),
                    ProgramCard(
                      title: "Bedroom hacks",
                      subtitle:
                          "Level up your sleep cave with our nonsense advice.",
                      imagePath: "assets/period_dates/image/meditation.jpg",
                      bgColor: Color(0xFF007367),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
     
    );
  }
}

class ProgramCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color bgColor;

  const ProgramCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
