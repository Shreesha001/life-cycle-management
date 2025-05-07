import 'package:flutter/material.dart';
import 'package:merge_app/features/health_and_wellness/screens/health_body_screens/health_body_breath_start_screen.dart';

class HealthBodyBreathScreen extends StatefulWidget {
  const HealthBodyBreathScreen({super.key});

  @override
  State<HealthBodyBreathScreen> createState() => _HealthBodyBreathScreenState();
}

class _HealthBodyBreathScreenState extends State<HealthBodyBreathScreen> {
  double duration = 5;
  final List<String> sounds = [
    'Ambient',
    'Space',
    'Lunar',
    'Inspira',
    'Silence',
    'Rain',
  ];
  String selectedSound = 'Ambient';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Breathwork',
          style: TextStyle(color: Colors.black87),
        ),
        leading: const BackButton(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.air, size: 40, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      '${duration.round()} minutes',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 30,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 10,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 18,
                      ),
                    ),
                    child: Slider(
                      value: duration,
                      min: 1,
                      max: 25,
                      divisions: 24, // 1-minute steps
                      label: '${duration.round()}',
                      activeColor: Colors.blueAccent,
                      onChanged: (value) {
                        setState(() {
                          duration = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sound',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children:
                        sounds.map((sound) {
                          final isSelected = selectedSound == sound;
                          return ChoiceChip(
                            label: Text(sound),
                            selected: isSelected,
                            selectedColor: Colors.blueAccent,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            onSelected: (_) {
                              setState(() {
                                selectedSound = sound;
                              });
                            },
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => HealthBodyBreathStartScreen(
                          duration: duration,
                          sound: selectedSound,
                        ),
                  ),
                );
              },
              child: const Text(
                'Start Breathwork',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
