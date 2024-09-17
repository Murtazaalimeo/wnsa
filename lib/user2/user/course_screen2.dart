import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Payment.dart';

class CourseDetailPage extends StatelessWidget {
  final String courseId;

  CourseDetailPage({required this.courseId});

  Future<String?> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.payment),
            onPressed: () async {
              var userId = await _getCurrentUserId();
              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('You must be logged in to enroll')),
                );
                return;
              }

              var courseSnapshot = await FirebaseFirestore.instance.collection('courses').doc(courseId).get();
              if (courseSnapshot.exists) {
                var courseData = courseSnapshot.data() as Map<String, dynamic>;
                String title = courseData['title'];
                double price = double.parse(courseData['price']); // Convert to double

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Payment(
                      userId: userId,
                      courseId: courseId,
                      courseTitle: title,
                      totalAmount: price,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('courses').doc(courseId).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('Course not found'));
                }

                var courseData = snapshot.data!.data() as Map<String, dynamic>;
                String title = courseData['title'];
                String description = courseData['description'];
                String price = courseData['price'];
                String imageUrl = courseData['image'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title: $title',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Description: $description',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Price: \$ $price',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    imageUrl.isNotEmpty
                        ? Image.network(
                      imageUrl,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                        : Container(),
                    SizedBox(height: 16.0),
                  ],
                );
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Modules',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _buildModulesList(),
            SizedBox(height: 16.0),
            Text(
              'Assignments',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            _buildAssignmentsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').doc(courseId).collection('modules').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No modules found'));
        }

        var modules = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: modules.map((module) {
            String description = module['description'];
            String mediaUrl = module['media'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Module Description: $description',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                mediaUrl.isNotEmpty
                    ? Image.network(
                  mediaUrl,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(),
                SizedBox(height: 16.0),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAssignmentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').doc(courseId).collection('assignments').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No assignments found'));
        }

        var assignments = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: assignments.map((assignment) {
            String description = assignment['description'];
            String mediaUrl = assignment['media'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assignment Description: $description',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                mediaUrl.isNotEmpty
                    ? Image.network(
                  mediaUrl,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                    : Container(),
                SizedBox(height: 16.0),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
