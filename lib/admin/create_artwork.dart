import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class UploadArtworkPage extends StatefulWidget {
  @override
  _UploadArtworkPageState createState() => _UploadArtworkPageState();
}

class _UploadArtworkPageState extends State<UploadArtworkPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _category;
  String? _size;
  String? _mediaType;
  String? _price;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadData() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();

      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference = FirebaseStorage.instance.ref().child('artworks/$fileName');
      UploadTask uploadTask = storageReference.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      // Upload data to Firestore
      FirebaseFirestore.instance.collection('Artwork').doc(_category).collection('Products').add({
        'image': downloadUrl,
        'size': _size,
        'mediaType': _mediaType,
        'price': _price,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload: $error')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Artwork'),
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
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Artwork Category',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Pets Portrait', 'Family Portrait', 'Wedding Couple', 'Others']
                      .map((category) => DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  ))
                      .toList(),
                  onChanged: (value) {
                    _category = value;
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Add Product Details',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: _image == null
                          ? Icon(
                        Icons.add_a_photo,
                        color: Colors.grey,
                        size: 50.0,
                      )
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Size',
                    border: OutlineInputBorder(),
                  ),
                  items: ['A4 size', '12\'\'x16\'\'', '18\'\'x24\'\'']
                      .map((size) => DropdownMenuItem<String>(
                    value: size,
                    child: Text(size),
                  ))
                      .toList(),
                  onChanged: (value) {
                    _size = value;
                  },
                  validator: (value) => value == null ? 'Please select a size' : null,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Media Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Charcoal (Black and White)', 'Color Pencil', 'Oil On Canvas', 'Acrylic On Canvas']
                      .map((mediaType) => DropdownMenuItem<String>(
                    value: mediaType,
                    child: Text(mediaType),
                  ))
                      .toList(),
                  onChanged: (value) {
                    _mediaType = value;
                  },
                  validator: (value) => value == null ? 'Please select a media type' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _price = value;
                  },
                  validator: (value) => value == null || value.isEmpty ? 'Please enter a price' : null,
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
