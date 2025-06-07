import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merge_app/features/my_diary/dairy_services.dart';
import 'package:merge_app/features/my_diary/widgets/text_color_picker.dart';
import 'package:merge_app/features/my_diary/widgets/theme_picker.dart';
import '../utils/colors.dart';

class CardDetailScreen extends StatefulWidget {
  final Map<String, dynamic> entry;

  const CardDetailScreen({Key? key, required this.entry}) : super(key: key);

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  File? _selectedImage;
  bool _isEditing = false;
  late DiaryService _diaryService;
  late Color backgroundColor;
  late Color textColor;

  @override
  void initState() {
    super.initState();
    _diaryService = DiaryService();
    _titleController = TextEditingController(text: widget.entry['title']);
    _descController = TextEditingController(text: widget.entry['desc']);
    backgroundColor = Color(widget.entry['backgroundColor'] ?? 0xFF0E1C2F);
    textColor = Color(widget.entry['textColor'] ?? 0xFFFFFFFF);

    final path = widget.entry['imagePath'];
    if (path != null && path is String && path.isNotEmpty && File(path).existsSync()) {
      _selectedImage = File(path);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _deleteImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    setState(() => _isEditing = false);

    final updatedEntry = {
      'title': _titleController.text,
      'desc': _descController.text,
      'imagePath': _selectedImage?.path ?? '',
      'date': widget.entry['date'],
      'emoji': widget.entry['emoji'],
      'hashtags': widget.entry['hashtags'],
      'backgroundColor': backgroundColor.value,
      'textColor': textColor.value,
      'id': widget.entry['id'],
    };

    try {
      await _diaryService.updateEntry(widget.entry['id'], updatedEntry);
      Navigator.pop(context, updatedEntry);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update entry: $e')),
      );
    }
  }

  void _deleteEntry() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Entry", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        content: Text(
          "Are you sure you want to delete this entry? This action cannot be undone.",
          style: TextStyle(color: textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: TextStyle(color: textColor)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await _diaryService.deleteEntry(widget.entry['id']);
        Navigator.pop(context, 'delete');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete entry: $e')),
        );
      }
    }
  }

  Widget _buildColorPicker({
    required String label,
    required Color currentColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: textColor)),
        SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 22,
            backgroundColor: currentColor,
            child: Icon(Icons.edit, size: 16, color: currentColor.computeLuminance() > 0.5 ? Colors.black : Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hashtags = widget.entry['hashtags'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: Icon(Icons.delete), onPressed: _deleteEntry),
          IconButton(icon: Icon(_isEditing ? Icons.check : Icons.edit), onPressed: _isEditing ? _saveChanges : _toggleEdit),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _isEditing
                    ? TextField(
                        key: ValueKey('titleEdit'),
                        controller: _titleController,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Enter title...',
                          hintStyle: TextStyle(color: textColor.withOpacity(0.54)),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
                        ),
                      )
                    : Container(
                        key: ValueKey('titleView'),
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: textColor, width: 1)),
                        ),
                        child: Text(
                          _titleController.text,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              if (_selectedImage != null && _selectedImage!.existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _isEditing
                    ? TextField(
                        key: ValueKey('descEdit'),
                        controller: _descController,
                        maxLines: null,
                        style: TextStyle(fontSize: 16, color: textColor),
                        decoration: InputDecoration(
                          hintText: 'Enter description...',
                          hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        _descController.text,
                        key: ValueKey('descView'),
                        style: TextStyle(fontSize: 16, color: textColor),
                      ),
              ),
              SizedBox(height: 20),
              if (hashtags.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: hashtags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: textColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 30),
              if (_isEditing)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image, color: Colors.white),
                      label: Text("Choose Image", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildColorPicker(
                          label: "Background",
                          currentColor: backgroundColor,
                          onTap: () => ThemePicker.show(
                            context: context,
                            currentColor: backgroundColor,
                            onSelected: (color) {
                              setState(() => backgroundColor = color);
                            },
                          ),
                        ),
                        _buildColorPicker(
                          label: "Text",
                          currentColor: textColor,
                          onTap: () => TextColorPicker.show(
                            context: context,
                            currentColor: textColor,
                            onSelected: (color) {
                              setState(() => textColor = color);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
