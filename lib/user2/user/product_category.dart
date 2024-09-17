import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'artdetail.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String category;

  CategoryProductsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Artwork').doc(category).collection('Products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> products = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              String productTitle = products[index]["mediaType"];
              String imagePath = products[index]["image"];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ArtworkDetailScreen(product: products[index])),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
