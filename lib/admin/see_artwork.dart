import 'package:flutter/material.dart';

import 'product_category.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SeeArtWorkScreen(),
    );
  }
}

class SeeArtWorkScreen extends StatefulWidget {
  @override
  _SeeArtWorkScreenState createState() => _SeeArtWorkScreenState();
}

class _SeeArtWorkScreenState extends State<SeeArtWorkScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Categories'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCard(categories[index], () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductCategory(),
                ),
              );
            });
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.brush,
              size: 40,
              color: Colors.black,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ArtworkListScreen extends StatelessWidget {
  final String category;

  ArtworkListScreen(this.category);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          'All artworks in the $category category will be displayed here.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

final List<String> categories = [
  'Pets Portraits',
  'Family Portraits',
  'Wedding Couple',
  'Others',
];
