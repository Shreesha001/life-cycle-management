import 'package:flutter/material.dart';

typedef OnTextColorSelected = void Function(Color selectedColor);

class TextColorPicker {
  static void show({
    required BuildContext context,
    required Color currentColor,
    required OnTextColorSelected onSelected,
  }) {
    final List<Color> textColors = [
      Colors.white,
      Colors.pinkAccent,
      Colors.tealAccent,
      Colors.amberAccent,
      Colors.lightBlueAccent,
      Colors.orangeAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.black,
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
                "Choose Text Color",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    textColors.map((color) {
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
