import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merge_app/core/theme/theme.dart';

class VehicleDocumentScreen extends StatefulWidget {
  const VehicleDocumentScreen({super.key});

  @override
  State<VehicleDocumentScreen> createState() => _VehicleDocumentScreenState();
}

class _VehicleDocumentScreenState extends State<VehicleDocumentScreen> {
  File? _capturedImage;
  final TextEditingController _nameController = TextEditingController();

  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _capturedImage = File(pickedFile.path);
      });
    }
  }

  void _saveDocument() {
    final imageName = _nameController.text;
    final imageFile = _capturedImage;

    if (imageName.isEmpty || imageFile == null) return;

    // TODO: Save logic here
    print('Saved: $imageName at ${imageFile.path}');
    Navigator.pop(context);
  }

  void _showImageFullScreen(File imageFile) {
    showDialog(
      context: context,
      builder: (_) => Dialog(child: Image.file(imageFile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Capture Document'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Row of document types
                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final docs = [
                        {
                          "title": "RC",
                          "image":
                              "lib/features/vehicle_manager/assets/car.jpg",
                        },
                        {
                          "title": "Insurance",
                          "image":
                              "lib/features/vehicle_manager/assets/car.jpg",
                        },
                        {
                          "title": "PUC",
                          "image":
                              "lib/features/vehicle_manager/assets/car.jpg",
                        },
                        {
                          "title": "Fitness",
                          "image":
                              "lib/features/vehicle_manager/assets/car.jpg",
                        },
                      ];
                      return _DocumentCard(
                        title: docs[index]["title"]!,
                        imagePath: docs[index]["image"]!,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                _capturedImage != null
                    ? Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap:
                                  () => _showImageFullScreen(_capturedImage!),
                              child: Image.file(
                                _capturedImage!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Icon(
                                    Icons.description,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Document Name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _capturedImage = null;
                                  _nameController.clear();
                                });
                              },
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _saveDocument,
                              icon: const Icon(Icons.save),
                              label: const Text('Save'),
                            ),
                          ],
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          // Bottom right add button
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _openCamera,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add_a_photo),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final String title;
  final String imagePath;

  const _DocumentCard({required this.title, required this.imagePath});

  void _showDocumentDialog(
    BuildContext context,
    String title,
    String imagePath,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Image.asset(imagePath),
            actions: [
              TextButton(
                child: const Text("Close"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showDocumentDialog(context, title, imagePath),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
