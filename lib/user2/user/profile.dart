import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String email = user.email!; // Email is used as the document ID

          await FirebaseFirestore.instance.collection('users').doc(email).set({
            'fullName': _fullNameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
            'address': _addressController.text,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile Saved Successfully')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/a1.jpg'),
                  backgroundColor: Colors.grey[200],
                ),
                SizedBox(height: 24.0),
                _buildTextField(_fullNameController, 'Full Name', Icons.person),
                SizedBox(height: 16.0),
                _buildTextField(_emailController, 'Email', Icons.email, keyboardType: TextInputType.emailAddress, ),
                SizedBox(height: 16.0),
                _buildTextField(_phoneController, 'Phone Number', Icons.phone, keyboardType: TextInputType.phone),
                SizedBox(height: 16.0),
                _buildTextField(_addressController, 'Address', Icons.home),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Save Profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, {TextInputType keyboardType = TextInputType.text, bool enabled = true}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
      keyboardType: keyboardType,
      enabled: enabled,
    );
  }
}
