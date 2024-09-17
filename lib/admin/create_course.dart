import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class UploadCoursePage extends StatefulWidget {
  @override
  _UploadCoursePageState createState() => _UploadCoursePageState();
}

class _UploadCoursePageState extends State<UploadCoursePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _courseImage;
  final List<Map<String, dynamic>> _modules = [];
  final List<Map<String, dynamic>> _assignments = [];
  final ImagePicker _picker = ImagePicker();

  void _addModule() {
    setState(() {
      _modules.add({'description': '', 'media': null});
    });
  }

  void _addAssignment() {
    setState(() {
      _assignments.add({'description': '', 'media': null});
    });
  }

  Future<void> _selectMedia(Map<String, dynamic> item) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        item['media'] = File(pickedFile.path);
      }
    });
  }

  Future<void> _selectCourseImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _courseImage = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadFile(File file, String path) async {
    Reference storageReference = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate()) {
      String courseId = FirebaseFirestore.instance.collection('courses').doc().id;

      String? courseImageUrl;
      if (_courseImage != null) {
        courseImageUrl = await _uploadFile(_courseImage!, 'courses/$courseId/course_image');
      }

      FirebaseFirestore.instance.collection('courses').doc(courseId).set({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'price': _priceController.text,
        'image': courseImageUrl,
      });

      for (int i = 0; i < _modules.length; i++) {
        String? moduleImageUrl;
        if (_modules[i]['media'] != null) {
          moduleImageUrl = await _uploadFile(_modules[i]['media'], 'courses/$courseId/modules/module$i');
        }

        FirebaseFirestore.instance.collection('courses').doc(courseId).collection('modules').doc('module${i + 1}').set({
          'description': _modules[i]['description'],
          'media': moduleImageUrl,
        });
      }

      for (int i = 0; i < _assignments.length; i++) {
        String? assignmentImageUrl;
        if (_assignments[i]['media'] != null) {
          assignmentImageUrl = await _uploadFile(_assignments[i]['media'], 'courses/$courseId/assignments/assignment$i');
        }

        FirebaseFirestore.instance.collection('courses').doc(courseId).collection('assignments').doc('assignment${i + 1}').set({
          'description': _assignments[i]['description'],
          'media': assignmentImageUrl,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Course'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Course Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a course title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _selectCourseImage,
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: _courseImage == null
                          ? Icon(
                        Icons.add_to_photos,
                        color: Colors.grey,
                        size: 50.0,
                      )
                          : Image.file(_courseImage!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: 'Course Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a course description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Text(
                  'Modules',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: _modules.map((module) {
                    int index = _modules.indexOf(module);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Module ${index + 1} Description',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            module['description'] = value;
                          },
                        ),
                        SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () => _selectMedia(module),
                          child: Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: module['media'] == null
                                  ? Icon(
                                Icons.add_to_photos,
                                color: Colors.grey,
                                size: 50.0,
                              )
                                  : Image.file(module['media'], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _addModule,
                  child: Text('Add Module'),
                ),
                SizedBox(height: 16.0),
                Text(
                  'Assignments',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: _assignments.map((assignment) {
                    int index = _assignments.indexOf(assignment);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Assignment ${index + 1} Description',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            assignment['description'] = value;
                          },
                        ),
                        SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () => _selectMedia(assignment),
                          child: Container(
                            height: 200.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: assignment['media'] == null
                                  ? Icon(
                                Icons.add_to_photos,
                                color: Colors.grey,
                                size: 50.0,
                              )
                                  : Image.file(assignment['media'], fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                      ],
                    );
                  }).toList(),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: _addAssignment,
                  child: Text('Add Assignment'),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                  child: OutlinedButton(
                    onPressed: _uploadData,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black, // text color
                      side: BorderSide(color: Colors.black), // outline color
                    ),
                    child: Text('Upload'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
