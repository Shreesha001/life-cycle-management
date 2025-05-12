import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';

class LifestylePreferencesScreen extends StatefulWidget {
  const LifestylePreferencesScreen({super.key});

  @override
  _LifestylePreferencesScreenState createState() =>
      _LifestylePreferencesScreenState();
}

class _LifestylePreferencesScreenState
    extends State<LifestylePreferencesScreen> {
  List<String> _interests = [];
  String _mealPreference = 'Vegetarian';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Lifestyle Preferences',
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
              'Interests',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0,
              children:
                  ['Reading', 'Fitness', 'Learning', 'Travel']
                      .map(
                        (interest) => ChoiceChip(
                          label: Text(interest, style: GoogleFonts.poppins()),
                          selected: _interests.contains(interest),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _interests.add(interest);
                              } else {
                                _interests.remove(interest);
                              }
                            });
                          },
                          selectedColor: primaryColor,
                          labelStyle: GoogleFonts.poppins(
                            color:
                                _interests.contains(interest)
                                    ? whiteColor
                                    : textPrimaryColor,
                          ),
                          backgroundColor: whiteColor.withOpacity(0.4),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
            Text(
              'Meal Preference',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _mealPreference,
              decoration: InputDecoration(
                labelText: 'Meal Preference',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.restaurant, color: primaryColor),
                filled: true,
                fillColor: whiteColor.withOpacity(0.4),
              ),
              items:
                  ['Vegetarian', 'Non-Vegetarian', 'Vegan']
                      .map(
                        (pref) => DropdownMenuItem(
                          value: pref,
                          child: Text(pref, style: GoogleFonts.poppins()),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _mealPreference = value!;
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
                      'Saved interests: ${_interests.join(", ")}, Meal: $_mealPreference',
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
