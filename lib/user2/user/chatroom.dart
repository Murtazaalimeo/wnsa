import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final bool isAdmin; // Add isAdmin parameter
  final String userEmail; // Add userEmail parameter

  ChatRoom({required this.chatRoomId, required this.isAdmin, required this.userEmail});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chatrooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No messages yet.'),
                  );
                }

                List<DocumentSnapshot> messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    Timestamp timestamp = message['timestamp'] ?? Timestamp.now(); // Handle null safely
                    DateTime dateTime = timestamp.toDate();
                    String formattedTime = DateFormat('hh:mm a').format(dateTime);
                    bool isUser = message['sender'] == widget.userEmail;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          if (!isUser) _buildAvatar(message['sender']),
                          SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment:
                              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isUser ? Colors.blue : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    message['message'],
                                    style: TextStyle(
                                      color: isUser ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  formattedTime,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          if (isUser) _buildAvatar(message['sender']),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Enter your message...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _sendMessage,
            child: Icon(Icons.send),
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String sender) {
    // Placeholder for user avatar, replace with actual user profile image
    return CircleAvatar(
      child: Text(sender[0].toUpperCase()),
    );
  }

  void _sendMessage() async {
    String messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      try {
        await _firestore
            .collection('chatrooms')
            .doc(widget.chatRoomId)
            .collection('messages')
            .add({
          'message': messageText,
          'sender': widget.userEmail, // Use userEmail as sender
          'timestamp': FieldValue.serverTimestamp(),
        });
        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
        _showErrorDialog('Error sending message. Please try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
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
