import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wnsa/auth/login.dart';

import 'admin/admin_assignment.dart';
import 'admin/create_artwork.dart';
import 'admin/create_course.dart';
import 'admin/create_post.dart';
import 'admin/product_detail_page.dart';
import 'admin/recent_post.dart';
import 'admin/see_artwork.dart';
import 'admin/orders_screen.dart';
import 'admin/enrollments_screen.dart';
import 'admin/see_course.dart';
import 'admin/chat.dart';


class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    AdminHomeScreen(),
    UploadArtworkPage(),
    UploadCoursePage(),
    OrdersScreen(),
    EnrollmentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 60.0,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.art_track, size: 30),
          Icon(Icons.create, size: 30),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.school, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: _onItemTapped,
        letIndexChange: (index) => true,
      ),
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  void _onCardTapped(BuildContext context, String title) {
    switch (title) {
      case 'Artwork':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SeeArtWorkScreen()),
        );
        break;
      case 'Course':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoursesGallery()),
        );
        break;
      case 'Post':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecentPostScreen()),
        );
        break;
      case 'Chat':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminChatListScreen()),
        );
        break;
      case 'Assignment':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssignmentScreen()),
        );
        break;
      case 'Create Post':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPostScreen()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),

        ],
        backgroundColor: Colors.white,
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
                  return GestureDetector(
                    onTap: () => _onCardTapped(context, adminCategories[index]),
                    child: _buildCard(index),
                  );
                },
              ),
            ),
          ],
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
        return Icon(Icons.library_books, size: 40, color: Colors.black);
      case 'Chat':
        return Icon(Icons.chat, size: 40, color: Colors.black);
      case 'Assignment':
        return Icon(Icons.assignment, size: 40, color: Colors.black);
      case 'Create Post':
        return Icon(Icons.post_add, size: 40, color: Colors.black);
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
  'Assignment',
  'Create Post',
];