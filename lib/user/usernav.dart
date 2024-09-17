import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wnsa/user/course.dart';
import 'package:wnsa/user/product_screen.dart';
import 'package:wnsa/user/profile.dart';




class home extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<home> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    Product(),
    CoursesListScreen(),
    profileuser(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_rounded),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.policy_sharp),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_user),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
