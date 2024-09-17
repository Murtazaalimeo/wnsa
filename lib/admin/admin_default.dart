import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AdminScreen(),
    );
  }
}

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // No navigation needed in this example
  }

  void _onCardTapped(String title) {
    // No navigation needed in this example
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Column(
          children: [
            Expanded(
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Create Artwork',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            label: 'Create Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Enrollments',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
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
  'Artwork',
  'Course',
  'Post',
  'Chat',
  'Assignment', // Changed from 'Assignment' to 'Progress'
  'Create Post', // Added 'Create Post' here
];
