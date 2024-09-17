import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: adminCategories.length,
          itemBuilder: (context, index) {
            return _buildCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    String title = adminCategories[index];

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getIconForCategory(title),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _getIconForCategory(String title) {
    switch (title) {
      case 'Artwork':
        return Icon(Icons.art_track, size: 40, color: Colors.black);
      case 'Course':
        return Icon(Icons.create, size: 40, color: Colors.black);
      case 'Post':
        return Icon(Icons.library_books, size: 40, color: Colors.black); // Adjusted icon for "Create Post"
      case 'Chat':
        return Icon(Icons.chat, size: 40, color: Colors.black);
      case 'Assignment': // Added icon for 'Progress'
        return Icon(Icons.assignment, size: 40, color: Colors.black);
      case 'Create Post':
        return Icon(Icons.post_add, size: 40, color: Colors.black); // Example icon for "Create Post"
      default:
        return Icon(Icons.category, size: 40, color: Colors.black);
    }
  }
}

final List<String> adminCategories = [
  'Course 1',
  'Course 2',
  'Course 3',
  'Course 4',
  'Course 5', // Changed from 'Assignment' to 'Progress'
  'Course 6', // Added 'Create Post' here
];
