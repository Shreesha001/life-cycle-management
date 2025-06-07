import 'package:flutter/material.dart';
import 'package:merge_app/features/my_diary/dairy_services.dart';
import 'package:merge_app/features/my_diary/screens/add_entry_page.dart';
import 'package:merge_app/features/my_diary/screens/card_detail_screen.dart';
import 'package:merge_app/features/my_diary/screens/search_screen.dart'; 
import 'package:merge_app/features/my_diary/utils/colors.dart';
import 'dart:io';

class DiaryHomePage extends StatefulWidget {
  @override
  _DiaryHomePageState createState() => _DiaryHomePageState();
}

class _DiaryHomePageState extends State<DiaryHomePage> {
  TextEditingController searchController = TextEditingController();
  late DiaryService _diaryService; // Instantiate DiaryService directly

  @override
  void initState() {
    super.initState();
    _diaryService = DiaryService(); // Initialize here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
         iconTheme: IconThemeData(
    color: Colors.white, 
  ),
        backgroundColor: appBarColor,
        title: Text("My Diary", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final entries = await _diaryService.getEntries().first; // Fetch entries for search
              showSearch(
                context: context,
                delegate: DiarySearchDelegate(entries),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _diaryService.getEntries(), // Use local instance
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final entries = snapshot.data ?? [];
          if (entries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '"The words you write ',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'now will one day hold',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'you together"',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black.withOpacity(0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CardDetailScreen(entry: entry),
                    ),
                  );

                  if (result == 'delete') {
                    // No need to update local state since StreamBuilder will handle it
                  } else if (result is Map<String, dynamic>) {
                    // No need to update local state since StreamBuilder will handle it
                  }
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry["date"] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                color: whiteColor,
                              ),
                            ),
                            Text(
                              entry["emoji"] ?? '',
                              style: TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entry["imagePath"] != null &&
                                entry["imagePath"].isNotEmpty &&
                                File(entry["imagePath"]).existsSync())
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(entry["imagePath"]),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry["title"] ?? '',
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    entry["desc"] ?? '',
                                    style: TextStyle(
                                      color: whiteColor.withOpacity(0.8),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () async {
            final newEntry = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddEntryPage()),
            );

            if (newEntry != null) {
              // No need to add to local state since Firestore will handle it
            }
          },
          child: Icon(Icons.add, size: 40),
          backgroundColor: Colors.blueAccent,
          shape: CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}