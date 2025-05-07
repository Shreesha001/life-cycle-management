import 'package:flutter/material.dart';
import 'package:merge_app/features/health_and_wellness/screens/health_body_screens/health_body_breath_screen.dart';
import 'health_body_breath_start_screen.dart'; // Update with correct path

class HealthBodyHomepageScreen extends StatelessWidget {
  const HealthBodyHomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE3F3FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Morning, Olivia! 👋\nStart your mindfulness journey',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.more_vert, color: Colors.black87),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: const [
                  Icon(Icons.mic_none, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Ask AI helper Silo...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(Icons.send, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  const _MindCard(title: "Meditate", color: Color(0xFFD1E9FF)),
                  const _MindCard(title: "Sleep", color: Color(0xFFB2E4FF)),

                  // 👇 Tap-enabled Breath card
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HealthBodyBreathScreen(),
                        ),
                      );
                    },
                    child: const _MindCard(
                      title: "Breath",
                      color: Color(0xFFCCEFFF),
                    ),
                  ),

                  const _MindCard(title: "Affirmate", color: Color(0xFFB2E0FF)),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.blueAccent,
      //   unselectedItemColor: Colors.grey,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }
}

class _MindCard extends StatelessWidget {
  final String title;
  final Color color;

  const _MindCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const Positioned(
            bottom: 12,
            right: 12,
            child: CircleAvatar(
              backgroundColor: Colors.black87,
              radius: 14,
              child: Icon(Icons.play_arrow, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
