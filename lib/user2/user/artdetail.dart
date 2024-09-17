import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wnsa/user2/user/payment2.dart';
import 'Payment.dart'; // Import Payment page

class ArtworkDetailScreen extends StatelessWidget {
  final DocumentSnapshot product;

  ArtworkDetailScreen({required this.product});

  Future<String?> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    String artId = product.id;
    String imagePath = product['image'];
    String size = product['size'];
    String mediaType = product['mediaType'];
    String price = product['price'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Artwork Details'),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), // Change icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300.0,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Size: $size',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Media Type: $mediaType',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                'Price: \$ $price',
                style: const TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String? userId = await _getCurrentUserId();
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('You must be logged in to buy')),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Payment2(
                          userId: userId!,
                          artId: artId,
                          artTitle: mediaType,
                          totalAmount: double.parse(price),
                        ),
                      ),
                    );
                  },
                  child: const Text('Buy Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
