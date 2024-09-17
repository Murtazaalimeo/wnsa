import 'package:flutter/material.dart';



class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.zero,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EnrolledCoursesScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
                    child: Text('Enrolled Courses'),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  width: 1,
                  thickness: 1,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AssignmentsScreen()),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16.0)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                    ),
                    child: Text('Assignments'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AssignmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'This is the Assignments screen',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}

class EnrolledCoursesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enrolled Courses', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'This is the Enrolled Courses screen',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
