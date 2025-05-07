import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:merge_app/core/constants/app_constants.dart';
import 'package:merge_app/core/theme/theme.dart';
import 'package:merge_app/features/document_management/widgets/reuseable_widgets.dart';
import 'package:share_plus/share_plus.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  final TextEditingController searchController = TextEditingController();
  final List<Map<String, String>> documents = [];
  List<Map<String, String>> filteredDocuments = [];
  File? _selectedImage;
  int? selectedUserIndex;

  final List<String> categories = [
    "Government IDs",
    "School marksheets",
    "College marksheets & degree",
    "Job related",
    "Medical history",
    "Resume",
    "Profile photo",
  ];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterDocuments);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterDocuments);
    searchController.dispose();
    super.dispose();
  }

  Future<File?> _pickImageOrFile() async {
    return await showModalBottomSheet<File>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (pickedFile != null) {
                    Navigator.pop(context, File(pickedFile.path));
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    Navigator.pop(context, File(pickedFile.path));
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Pick a File'),
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );
                  if (result != null && result.files.single.path != null) {
                    Navigator.pop(context, File(result.files.single.path!));
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterDocuments() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredDocuments =
          documents.where((doc) {
            final matchesSearch =
                doc['name']!.toLowerCase().contains(query) ||
                doc['category']!.toLowerCase().contains(query) ||
                (doc['subCategory'] ?? '').toLowerCase().contains(query);

            final matchesUser =
                selectedUserIndex == null ||
                doc['userIndex'] == selectedUserIndex.toString();

            return matchesSearch && matchesUser;
          }).toList();
    });
  }

  void _showAddDocumentSheet(BuildContext context, String category) async {
    final pickedFile = await _pickImageOrFile();

    if (pickedFile == null) return;

    final nameController = TextEditingController();
    final subCategoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 16,
            right: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(pickedFile, height: 150),
                const SizedBox(height: 10),
                ReusableInputField(
                  controller: nameController,
                  hintText: 'Document Name',
                ),
                const SizedBox(height: 10),
                if (category == "Job related")
                  ReusableInputField(
                    controller: subCategoryController,
                    hintText: 'Sub-category',
                  ),
                const SizedBox(height: 20),
                ReusableButton(
                  text: 'Save',
                  onPressed: () {
                    setState(() {
                      documents.add({
                        'name': nameController.text,
                        'expiry': '',
                        'category': category,
                        'subCategory': subCategoryController.text,
                        'addedDate': DateTime.now().toIso8601String(),
                        'imagePath': pickedFile.path,
                        'userIndex': selectedUserIndex?.toString() ?? '0',
                      });
                      _filterDocuments();
                    });
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void _viewDocument(Map<String, String> doc) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(doc['name'] ?? 'Document'),
            content:
                doc['imagePath'] != null
                    ? Image.file(File(doc['imagePath']!))
                    : const Text("No image available."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _shareDocument(Map<String, String> doc) async {
    final imagePath = doc['imagePath'];
    if (imagePath != null && File(imagePath).existsSync()) {
      await Share.shareXFiles([
        XFile(imagePath),
      ], text: 'Sharing ${doc['name']} document');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No image file available to share.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    documents.sort(
      (a, b) => DateTime.parse(
        b['addedDate']!,
      ).compareTo(DateTime.parse(a['addedDate']!)),
    );

    if (searchController.text.isEmpty) {
      filteredDocuments = documents;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCustomHeader(),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: "Search documents...",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.secondaryColor,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "All Members",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 8,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder:
                      (_, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedUserIndex = index;
                            _filterDocuments(); // reapply filter
                          });
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              selectedUserIndex == index
                                  ? Colors.blue
                                  : AppColors.secondaryColor,
                          child: Text('U$index'),
                        ),
                      ),
                ),
              ),

              const SizedBox(height: 20),
              Text(
                "My Documents",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final cat = categories[index];
                    return Container(
                      width: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.secondaryColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          ReusableButton(
                            text: "Add Document",
                            onPressed:
                                () => _showAddDocumentSheet(context, cat),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Uploaded Documents",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (filteredDocuments.isEmpty)
                const Text("No matching documents found."),
              if (filteredDocuments.isNotEmpty) _buildDocumentList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Stack(
        children: [
          // Vertical line
          Positioned(
            left: 16, // Adjusted to center the dot on the line
            top: 0,
            bottom: 0,
            child: Container(width: 2, color: Colors.grey.shade300),
          ),
          Column(
            children:
                filteredDocuments
                    .map((doc) => _buildDocumentTile(doc))
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile(Map<String, String> doc) {
    final date = DateFormat.yMMMd().format(DateTime.parse(doc['addedDate']!));
    final creator = "Maruf";

    return GestureDetector(
      onTap: () {
        final imagePath = doc['imagePath'];
        debugPrint('Image path on tap: $imagePath');

        if (imagePath != null && imagePath.isNotEmpty) {
          showDialog(
            context: context,
            builder:
                (_) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      errorBuilder:
                          (_, __, ___) => const Text('Failed to load image'),
                    ),
                  ),
                ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No image available for this document'),
            ),
          );
        }
      },

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppConstants.spacing8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline Dot
            Container(
              width: 24,
              height: 24,
              alignment: Alignment.topRight,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacing4),
            // Document Card
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacing8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Date, Name, Menu
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Expanded(
                          flex: 3,
                          child: Text(
                            doc['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'view') _viewDocument(doc);
                            if (value == 'share') _shareDocument(doc);
                            if (value == 'delete') {
                              setState(() {
                                documents.remove(doc);
                                _filterDocuments();
                              });
                            }
                          },
                          itemBuilder:
                              (context) => const [
                                PopupMenuItem(
                                  value: 'view',
                                  child: Text('View'),
                                ),
                                PopupMenuItem(
                                  value: 'share',
                                  child: Text('Share'),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(creator, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeader() {
    final today = DateFormat('EEEE, MMMM d yyyy').format(DateTime.now());
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      height: 140, // enough height to vertically center the button
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // Greeting Texts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                today,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome Maruf',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Have a nice day!',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          // Invite Button
          Positioned(
            right: 0,
            top: 40, // adjust to align to vertical center-ish
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                // Chalo, invite ka logic yahan daalo
                debugPrint('Invite button tapped');
              },
              child: const Text('Invite'),
            ),
          ),
        ],
      ),
    );
  }
}
