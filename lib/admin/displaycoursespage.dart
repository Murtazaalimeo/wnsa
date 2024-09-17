import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisplayCoursePage extends StatelessWidget {
  final DocumentReference courseRef;

  DisplayCoursePage({required this.courseRef});

  Future<Map<String, dynamic>> _fetchCourseData() async {
    var courseSnapshot = await courseRef.get();
    var modulesSnapshot = await courseRef.collection('modules').get();
    var assignmentsSnapshot = await courseRef.collection('assignments').get();

    return {
      'courseData': courseSnapshot.data(),
      'modules': modulesSnapshot.docs,
      'assignments': assignmentsSnapshot.docs,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchCourseData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching course details'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Course does not exist'));
          }

          var courseData = snapshot.data!['courseData'];
          var modules = snapshot.data!['modules'];
          var assignments = snapshot.data!['assignments'];

          String courseTitle = courseData['title'];
          String imagePath = courseData['image'];
          String description = courseData['description'];
          String price = courseData['price'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Image.network(
                    imagePath,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Modules',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: modules.map<Widget>((moduleDoc) {
                      var module = moduleDoc.data();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            module['description'],
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                          Image.network(
                            module['media'],
                            height: 200.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Assignments',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: assignments.map<Widget>((assignmentDoc) {
                      var assignment = assignmentDoc.data();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            assignment['description'],
                            style: TextStyle(fontSize: 14.0),
                          ),
                          SizedBox(height: 8.0),
                          Image.network(
                            assignment['media'],
                            height: 200.0,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 16.0),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Price: \$${price}',
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Placeholder for edit course action
                          },
                          child: Text('Edit Course'),
                        ),
                        SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // Placeholder for delete course action
                          },
                          child: Text('Delete Course'),
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.white, // background color
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
