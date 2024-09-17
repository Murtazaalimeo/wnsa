import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;

  CourseDetailsScreen({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('courses').doc(courseId).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Course Not Found');
            }
            return Text(snapshot.data!['courseTitle']);
          },
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('courses').doc(courseId).snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Course Not Found');
            }
            Map<String, dynamic> courseData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (courseData['introVideoUrl'] != null) ...[
                  Text(
                    'Intro Video:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  AspectRatio(
                    aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: VideoWidget(videoUrl: courseData['introVideoUrl']),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
                Text(
                  'Course Description:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(courseData['courseDescription'], style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text(
                  'Modules:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                ...courseData['modules'].entries.map((entry) {
                  String moduleName = entry.key;
                  Map<String, dynamic> moduleData = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Module: $moduleName',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text('Module Name: ${moduleData['name']}', style: TextStyle(fontSize: 14)),
                      if (moduleData['videoUrl'] != null) ...[
                        SizedBox(height: 8),
                        AspectRatio(
                          aspectRatio: 16 / 9, // Adjust aspect ratio as needed
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: VideoWidget(videoUrl: moduleData['videoUrl']),
                          ),
                        ),
                      ],
                      SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class VideoWidget extends StatefulWidget {
  final String videoUrl;

  VideoWidget({required this.videoUrl});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true; // Ensure state is updated only after initialization
        });
        _controller.setLooping(true);
        _controller.play();
      }).catchError((error) {
        print('Error initializing video player: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator());
  }
}
