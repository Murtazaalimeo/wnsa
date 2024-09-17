import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:wnsa/user2/user/course_screen2.dart';

class CourseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('courses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No courses found'));
          }

          var courses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var course = courses[index];
              String courseId = course.id;
              String title = course['title'];
              String description = course['description'];
              String price = course['price'];
              String imageUrl = course['image'];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CourseDetailPage(courseId: courseId)),
                  );
                },
                child: Card(
                  elevation: 3.0,
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          description,
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Price: \$ $price',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        imageUrl.isNotEmpty
                            ? Image.network(
                          imageUrl,
                          height: 150.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
