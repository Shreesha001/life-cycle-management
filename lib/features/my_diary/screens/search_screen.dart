import 'package:flutter/material.dart';
import '../screens/card_detail_screen.dart';
import '../utils/colors.dart';

class DiarySearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> entries;

  DiarySearchDelegate(this.entries);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        iconTheme: IconThemeData(color: whiteColor),
        toolbarTextStyle: TextStyle(color: whiteColor, fontSize: 18),
        titleTextStyle: TextStyle(color: whiteColor, fontSize: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: whiteColor),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: whiteColor),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = entries.where((entry) {
      final q = query.toLowerCase();
      return entry['title'].toLowerCase().contains(q) ||
          entry['desc'].toLowerCase().contains(q);
    }).toList();

    return _buildEntryList(context, results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = entries.where((entry) {
      final q = query.toLowerCase();
      return entry['title'].toLowerCase().contains(q) ||
          entry['desc'].toLowerCase().contains(q);
    }).toList();

    return _buildEntryList(context, suggestions);
  }

  Widget _buildEntryList(
    BuildContext context,
    List<Map<String, dynamic>> data,
  ) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No matching entries found.',
          style: TextStyle(color: textSecondaryColor, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final entry = data[index];

        return Card(
          color: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: Text(
              entry['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              entry['desc'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardDetailScreen(entry: entry),
                ),
              );

              if (result == 'delete') {
                close(context, 'refresh');
              } else if (result is Map) {
                close(context, 'refresh');
              }
            },
          ),
        );
      },
    );
  }
}