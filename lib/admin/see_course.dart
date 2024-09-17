import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'displaycoursespage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Courses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoursesGallery(),
    );
  }
}

class CoursesGallery extends StatelessWidget {
  final CollectionReference _coursesCollection =
  FirebaseFirestore.instance.collection('courses');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Courses Gallery',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Colors.blue,
            height: 2.0,
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: _coursesCollection.get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching courses'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No courses available'));
          }

          final courses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              var course = courses[index];
              String courseTitle = course['title'];
              String imagePath = course['image'];

              return _buildCourseCard(context, courseTitle, imagePath, course.reference);
            },
          );
        },
      ),
    );
  }

  Widget _buildCourseCard(
      BuildContext context,
      String courseTitle,
      String imagePath,
      DocumentReference courseRef,
      ) {
    return GestureDetector(
      onTap: () {
        // Navigate to course details page with course details
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisplayCoursePage(courseRef: courseRef),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.network(
                imagePath,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                courseTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
