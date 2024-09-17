import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'art.dart';
import 'courselist.dart';
import 'progress.dart';
import 'profile.dart';
import 'chatroom.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _chatRoomId;

  List<Widget> _widgetOptions = <Widget>[
    ArtworkGallery(),
    CourseListPage(),
    Center(child: CircularProgressIndicator()),
    ProgressScreen(),
    ProfileScreen(),
  ];

  bool _isChatRoomInitialized = false;

  @override
  void initState() {
    super.initState();
    _initiateChatWithAdmin();
  }

  void _initiateChatWithAdmin() async {
    String adminEmail = 'admin@gmail.com';
    String userEmail = _auth.currentUser!.email!;
    _chatRoomId = _generateChatRoomId(userEmail, adminEmail);

    DocumentReference chatRoomRef = _firestore.collection('chatrooms').doc(_chatRoomId);
    DocumentSnapshot chatRoomDoc = await chatRoomRef.get();

    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        'participants': [userEmail, adminEmail],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    setState(() {
      _widgetOptions[2] = ChatRoom(chatRoomId: _chatRoomId, userEmail: userEmail,   isAdmin: false, ); // Pass userEmail here
      _isChatRoomInitialized = true;
    });
  }

  String _generateChatRoomId(String userEmail, String adminEmail) {
    List<String> emails = [userEmail, adminEmail]..sort();
    return '${emails[0]}_${emails[1]}';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isChatRoomInitialized
          ? _widgetOptions.elementAt(_selectedIndex)
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
