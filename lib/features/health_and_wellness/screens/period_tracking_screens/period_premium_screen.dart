import 'package:flutter/material.dart';

class PeriodPremiumScreen extends StatelessWidget {
  const PeriodPremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Image.asset(
              'assets/period_dates/image/period_img.jpg', // Replace with your actual asset
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              'My Period Calendar ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Premium',
              style: TextStyle(fontSize: 18, color: Colors.pink),
            ),
            const SizedBox(height: 30),
            _buildFeatureTile(
              Icons.show_chart,
              'Advanced personal statistics',
              'Discover your body patterns and find out chances of pregnancy',
            ),
            _buildFeatureTile(
              Icons.widgets,
              'Helpful widgets',
              'Get your period and ovulation predictions without opening the app',
            ),
            _buildFeatureTile(
              Icons.health_and_safety,
              'Health reports',
              'Get the comprehensive view of your cycle, symptoms, moods, etc. and share it with a doctor if needed',
            ),
            _buildFeatureTile(
              Icons.analytics,
              'Cycle phase analysis',
              'Learn how your mood, symptoms, and chances of getting pregnant change with each cycle phase',
            ),
            const SizedBox(height: 20),
            _buildTrialToggle(),
            const SizedBox(height: 15),
            _buildPricingOptions(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                // Handle premium action
              },
              child: const Text(
                'Get Premium',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                // Handle payment info
              },
              child: const Text(
                'Payment information',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: Colors.pink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
    );
  }

  Widget _buildTrialToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Expanded(
            child: Text(
              'Not sure yet? Activate your free trial!',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Switch(value: false, onChanged: null), // Disabled by default
        ],
      ),
    );
  }

  Widget _buildPricingOptions() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.pink),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 Year',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹136.66 per month',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Chip(
                    label: Text(
                      'Save 50%',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.pink,
                  ),
                  Text(
                    '₹1,640.04 per year',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 Month',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹272.00 per month',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
