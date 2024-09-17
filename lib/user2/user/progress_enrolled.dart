import 'package:flutter/material.dart';

void main() {
  runApp(UserApp());
}

class UserApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CoursesListPage(),
    );
  }
}

class CoursesListPage extends StatelessWidget {
  final List<Course> courses = [
    Course(
      title: 'Flutter Development',
      description: 'Learn to build Flutter apps from scratch.',
      demoVideoUrl: 'https://www.example.com/demo_video_url',
      modules: [
        Module(title: 'Introduction to Flutter', videoUrl: 'https://www.example.com/intro_video_url'),
        Module(title: 'Building UI with Flutter', videoUrl: 'https://www.example.com/ui_video_url'),
      ],
      assignments: [
        Assignment(title: 'Assignment 1: Basic Layouts', videoUrl: 'https://www.example.com/assignment1_video_url'),
        Assignment(title: 'Assignment 2: State Management', videoUrl: 'https://www.example.com/assignment2_video_url'),
      ],
      price: 49.99,
    ),
    // Add more courses as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Development',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to detailed course view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(course: courses[index]),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9, // Assuming a standard aspect ratio for videos
                      child: Container(
                        color: Colors.grey, // Placeholder color
                        child: Center(
                          child: IconButton(
                            icon: Icon(Icons.play_circle_filled, size: 50.0),
                            onPressed: () {
                              // Implement video playback functionality
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Description:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      courses[index].description,
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Modules:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: courses[index].modules.map((module) {
                        return ExpansionTile(
                          title: Text(module.title),
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9, // Assuming a standard aspect ratio for videos
                              child: Container(
                                color: Colors.grey, // Placeholder color
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.play_circle_filled, size: 50.0),
                                    onPressed: () {
                                      // Implement video playback functionality
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Assignments:',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: courses[index].assignments.map((assignment) {
                        return ExpansionTile(
                          title: Text(assignment.title),
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9, // Assuming a standard aspect ratio for videos
                              child: Container(
                                color: Colors.grey, // Placeholder color
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.play_circle_filled, size: 50.0),
                                    onPressed: () {
                                      // Implement video playback functionality
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    // SizedBox(height: 16.0),
                    // Text(
                    //   'Price: \$${courses[index].price.toStringAsFixed(2)}',
                    //   style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  CourseDetailsPage({required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 16 / 9, // Assuming a standard aspect ratio for videos
                child: Container(
                  color: Colors.grey, // Placeholder color
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.play_circle_filled, size: 50.0),
                      onPressed: () {
                        // Implement video playback functionality
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Description:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              Text(
                course.description,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Modules:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: course.modules.map((module) {
                  return ExpansionTile(
                    title: Text(module.title),
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9, // Assuming a standard aspect ratio for videos
                        child: Container(
                          color: Colors.grey, // Placeholder color
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.play_circle_filled, size: 50.0),
                              onPressed: () {
                                // Implement video playback functionality
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Assignments:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: course.assignments.map((assignment) {
                  return ExpansionTile(
                    title: Text(assignment.title),
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9, // Assuming a standard aspect ratio for videos
                        child: Container(
                          color: Colors.grey, // Placeholder color
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.play_circle_filled, size: 50.0),
                              onPressed: () {
                                // Implement video playback functionality
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              // SizedBox(height: 16.0),
              // Text(
              //   'Price: \$${course.price.toStringAsFixed(2)}',
              //   style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class Course {
  final String title;
  final String description;
  final String demoVideoUrl;
  final List<Module> modules;
  final List<Assignment> assignments;
  final double price;

  Course({
    required this.title,
    required this.description,
    required this.demoVideoUrl,
    required this.modules,
    required this.assignments,
    required this.price,
  });
}

class Module {
  final String title;
  final String videoUrl;

  Module({
    required this.title,
    required this.videoUrl,
  });
}

class Assignment {
  final String title;
  final String videoUrl;

  Assignment({
    required this.title,
    required this.videoUrl,
  });
}
