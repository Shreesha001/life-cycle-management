import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),

      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.06),
            Image.asset(
              'assets/onboarding.png',
              height: screenHeight * 0.35,
              width: screenWidth * 0.8,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.04),
            const Text(
              'Organize and Manage',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A3A7B),
              ),
            ),
            const Text(
              'your Lifestyle',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFA726),
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Gain valuable insights into your daily habits and routines, empowering you to make smarter choices for a healthier, more balanced lifestyle.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2A3A7B),
                  height: 1.5,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3A7B),
                  minimumSize: Size(double.infinity, screenHeight * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: screenWidth * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
