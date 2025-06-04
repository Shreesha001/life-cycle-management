import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merge_app/features/my_diary/dairy_services.dart'; 
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
  late DiaryService _diaryService; // Instantiate DiaryService directly

  @override
  void initState() {
    super.initState();
    _diaryService = DiaryService(); // Initialize here
    _titleController = TextEditingController(text: widget.entry['title']);
    _descController = TextEditingController(text: widget.entry['desc']);

    final path = widget.entry['imagePath'];
    if (path != null &&
        path is String &&
        path.isNotEmpty &&
        File(path).existsSync()) {
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
    setState(() {
      _isEditing = false;
    });
    final updatedEntry = {
      'title': _titleController.text,
      'desc': _descController.text,
      'imagePath': _selectedImage?.path ?? '',
      'date': widget.entry['date'],
      'emoji': widget.entry['emoji'],
      'hashtags': widget.entry['hashtags'],
    };
    try {
      await _diaryService.updateEntry(widget.entry['id'], updatedEntry); // Use local instance
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          "Delete Entry",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete this entry? This action cannot be undone.",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text("Delete", style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await _diaryService.deleteEntry(widget.entry['id']); // Use local instance
        Navigator.pop(context, 'delete');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete entry: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hashtags = widget.entry['hashtags'] as List<dynamic>? ?? [];

    return Scaffold(
      backgroundColor: bgc,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: _deleteEntry,
          ),
          IconButton(
            icon: Icon(
              _isEditing ? Icons.check : Icons.edit,
              color: Colors.white,
            ),
            onPressed: _isEditing ? _saveChanges : _toggleEdit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _isEditing
                  ? TextField(
                      controller: _titleController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter title...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.white, width: 1),
                        ),
                      ),
                      child: Text(
                        _titleController.text,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              if (_selectedImage != null && _selectedImage!.existsSync())
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              _isEditing
                  ? TextField(
                      controller: _descController,
                      maxLines: null,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter description...',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    )
                  : Text(
                      _descController.text,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
              SizedBox(height: 20),
              if (hashtags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  children: hashtags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white70),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 30),
              if (_isEditing)
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: whiteColor,
                  ),
                  label: Text(
                    "Select Image",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}