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
  late DiaryService _diaryService;

  @override
  void initState() {
    super.initState();
    _diaryService = DiaryService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: appBarColor,
        title: Text("My Diary", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final entries = await _diaryService.getEntries().first;
              showSearch(
                context: context,
                delegate: DiarySearchDelegate(entries),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding:const EdgeInsets.only(top: 16.0),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _diaryService.getEntries(),
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
                  },
                  child: Padding(
                    
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CardDetailScreen(entry: entry),
          ),
        );
            },
            child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
        color: Colors.grey.withOpacity(0.15),
        width: 1,
            ),
            boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry["title"] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Until ${entry["date"] ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Text(
          entry["emoji"] ?? '',
          style: const TextStyle(fontSize: 22),
        ),
            ],
          ),
        ),
        
          ),
        ),
        
                );
              },
            );
          },
        ),
      ),

      /// 🌟 Floating Action Button with Label Above
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: appBarColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Start Writing\nYour Day',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          CustomPaint(
            size: Size(20, 10),
            painter: TrianglePainter(color: primaryColor),
          ),
          SizedBox(height: 5,),
          SizedBox(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: () async {
                final newEntry = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEntryPage()),
                );
              },
              child: Icon(Icons.edit_note, size: 40),
              backgroundColor: Colors.orangeAccent,
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

/// 🎯 Triangle painter for speech bubble tail
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
