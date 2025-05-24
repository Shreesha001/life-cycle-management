import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';

class AIPersonalizationScreen extends StatefulWidget {
  const AIPersonalizationScreen({super.key});

  @override
  _AIPersonalizationScreenState createState() =>
      _AIPersonalizationScreenState();
}

class _AIPersonalizationScreenState extends State<AIPersonalizationScreen> {
  String _aiLanguage = 'English';
  String _aiVoice = 'Female';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'AI & Personalization',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: whiteColor,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: whiteColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Assistant Settings',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _aiLanguage,
              decoration: InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.language, color: primaryColor),
                filled: true,
                fillColor: whiteColor.withOpacity(0.4),
              ),
              items:
                  ['English', 'Spanish', 'French']
                      .map(
                        (lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang, style: GoogleFonts.poppins()),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _aiLanguage = value!;
                });
              },
              style: GoogleFonts.poppins(color: textPrimaryColor),
              dropdownColor: whiteColor,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _aiVoice,
              decoration: InputDecoration(
                labelText: 'Voice',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.record_voice_over, color: primaryColor),
                filled: true,
                fillColor: whiteColor.withOpacity(0.4),
              ),
              items:
                  ['Female', 'Male', 'Neutral']
                      .map(
                        (voice) => DropdownMenuItem(
                          value: voice,
                          child: Text(voice, style: GoogleFonts.poppins()),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _aiVoice = value!;
                });
              },
              style: GoogleFonts.poppins(color: textPrimaryColor),
              dropdownColor: whiteColor,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Language: $_aiLanguage, Voice: $_aiVoice',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: secondaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Save', style: GoogleFonts.poppins(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
