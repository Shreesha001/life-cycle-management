import 'package:flutter/material.dart';

typedef OnThemeSelected = void Function(Color selectedColor);

class ThemePicker {
  static void show({
    required BuildContext context,
    required Color currentColor,
    required OnThemeSelected onSelected,
  }) {
   final List<Color> themeColors = [
  Color(0xFF0E1C2F), // Deep navy (original dark theme)
  Color(0xFF1E1E2E), // Dark purple/blue hybrid
  Color(0xFF121212), // Classic dark mode
  Colors.teal.shade700, // Deep teal
  Color(0xFF37474F), // Blue-grey
  Color(0xFF1A237E), // Rich indigo
  Color(0xFF2C2C54), // Dark lavender-indigo hybrid
  Color(0xFF223843), // Muted cyan
  Color(0xFF0F4C75), // Deep steel blue
  Color(0xFF263238), // Charcoal grey
  Color(0xFF3E2723), // Earthy deep brown
];



    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF1E2A47),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Theme",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    themeColors.map((color) {
                      return GestureDetector(
                        onTap: () {
                          onSelected(color);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  currentColor == color
                                      ? Colors.white
                                      : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
