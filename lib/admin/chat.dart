import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../user2/user/chatroom.dart';

class AdminChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Messages'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _getUsersWithChatRooms(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var usersWithChatRooms = snapshot.data!;

          if (usersWithChatRooms.isEmpty) {
            return Center(
              child: Text('No users with chat rooms found.'),
            );
          }

          return ListView.builder(
            itemCount: usersWithChatRooms.length,
            itemBuilder: (context, index) {
              var user = usersWithChatRooms[index];
              var userEmail = user.id; // Assuming user document ID is the email

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 3.0,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  title: Text(
                    userEmail,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.chat),
                  onTap: () async {
                    try {
                      String? chatRoomId = await _getOrCreateChatRoomId(userEmail);
                      if (chatRoomId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              chatRoomId: chatRoomId,
                              isAdmin: true, // Pass isAdmin true for admin view
                              userEmail: userEmail, // Pass user email to chat room
                            ),
                          ),
                        );
                      } else {
                        _showErrorDialog(context, 'No existing chat room found.');
                      }
                    } catch (e) {
                      _showErrorDialog(context, 'Error: $e');
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getUsersWithChatRooms() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      print('Error: currentUser or email is null');
      return [];
    }
    final currentUserEmail = currentUser.email!;

    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection('roles').get();
    List<DocumentSnapshot> users = usersSnapshot.docs;

    QuerySnapshot chatRoomsSnapshot = await FirebaseFirestore.instance.collection('chatrooms').get();
    List<DocumentSnapshot> chatRooms = chatRoomsSnapshot.docs;

    Set<String> chatRoomIds = chatRooms.map((doc) => doc.id).toSet();

    List<DocumentSnapshot> usersWithChatRooms = users.where((user) {
      String userEmail = user.id;
      String chatRoomId = _generateChatRoomId(currentUserEmail, userEmail);

      return chatRoomIds.contains(chatRoomId);
    }).toList();

    return usersWithChatRooms;
  }

  Future<String?> _getOrCreateChatRoomId(String userEmail) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || currentUser.email == null) {
      print('Error: currentUser or email is null');
      return null;
    }
    final currentUserEmail = currentUser.email!;

    String chatRoomId = _generateChatRoomId(currentUserEmail, userEmail);

    DocumentReference chatRoomRef = FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId);
    DocumentSnapshot chatRoomDoc = await chatRoomRef.get();

    if (!chatRoomDoc.exists) {
      await chatRoomRef.set({
        'participants': [currentUserEmail, userEmail],
        'timestamp': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }

  String _generateChatRoomId(String email1, String email2) {
    List<String> emails = [email1, email2]..sort();
    return '${emails[0]}_${emails[1]}';
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
