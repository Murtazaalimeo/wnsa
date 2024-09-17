import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

// Assignment class definition
class Assignment {
  final String id;
  final String studentId;
  final String courseTitle;
  final String moduleNumber;
  final String assignmentNumber;
  String? adminMedia;

  Assignment({
    required this.id,
    required this.studentId,
    required this.courseTitle,
    required this.moduleNumber,
    required this.assignmentNumber,
    this.adminMedia,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Assignment Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AssignmentScreen(),
    );
  }
}

class AssignmentScreen extends StatefulWidget {
  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  final List<Assignment> _assignments = [
    Assignment(
      id: '001',
      studentId: 'S001',
      courseTitle: 'Mathematics',
      moduleNumber: 'Module 3',
      assignmentNumber: 'Assignment 1',
    ),
    Assignment(
      id: '002',
      studentId: 'S002',
      courseTitle: 'English Literature',
      moduleNumber: 'Module 2',
      assignmentNumber: 'Assignment 2',
    ),
  ];

  final Map<String, bool> _expanded = {};

  final TextEditingController _courseTitleController = TextEditingController();
  final TextEditingController _moduleNumberController = TextEditingController();
  final TextEditingController _assignmentNumberController = TextEditingController();

  Widget _buildAssignmentCard(Assignment assignment) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Course Title: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${assignment.courseTitle}'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  'Module no: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${assignment.moduleNumber}'),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Text(
                  'Assignment no: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${assignment.assignmentNumber}'),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Submitted Assignment',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                // Placeholder for media display logic
              },
              child: Container(
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: assignment.adminMedia != null
                      ? Icon(
                    Icons.insert_drive_file,
                    color: Colors.grey,
                    size: 50.0,
                  )
                      : Icon(
                    Icons.add_to_photos,
                    color: Colors.grey,
                    size: 50.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _downloadAssignment(assignment.id);
                  },
                  child: Text('Download'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // Placeholder for delete logic
                    });
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondCard(Assignment assignment) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text(
              'Submit Reviewed Assignment',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _courseTitleController,
              decoration: InputDecoration(
                labelText: 'Course Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _moduleNumberController,
                    decoration: InputDecoration(
                      labelText: 'Module no',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _assignmentNumberController,
                    decoration: InputDecoration(
                      labelText: 'Assignment no',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                _selectAdminMedia(assignment.id);
              },
              child: Container(
                height: 100.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: assignment.adminMedia != null
                      ? Icon(
                    Icons.check_circle,
                    color: Colors.green[600],
                    size: 50.0,
                  )
                      : Icon(
                    Icons.add_to_photos,
                    color: Colors.grey,
                    size: 50.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            GestureDetector(
              onTap: () {
                _selectAdminMedia(assignment.id);
              },
              child: Text(
                'Select Assignment',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _submitAssignment(assignment.id);
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      assignment.adminMedia = null;
                    });
                  },
                  child: Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      assignment.adminMedia = null;
                    });
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadAssignment(String assignmentId) async {
    // Placeholder for download logic
    print('Downloading assignment with ID: $assignmentId');
  }

  void _selectAdminMedia(String assignmentId) {
    // Placeholder for media selection logic
    setState(() {
      _assignments
          .firstWhere((assignment) => assignment.id == assignmentId)
          .adminMedia = 'selected_media_placeholder';
    });
  }

  void _submitAssignment(String assignmentId) {
    // Placeholder for submit logic
    print('Submitting assignment with ID: $assignmentId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Assignments',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _assignments.map((assignment) {
              _expanded.putIfAbsent(assignment.studentId, () => false);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _expanded[assignment.studentId] =
                        !_expanded[assignment.studentId]!;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[50],
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.blueGrey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Student ID: ${assignment.studentId}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                    ),
                  ),
                  if (_expanded[assignment.studentId]!)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildAssignmentCard(assignment),
                          _buildSecondCard(assignment),
                        ],
                      ),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
