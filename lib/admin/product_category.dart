import 'package:flutter/material.dart';

import 'product_detail_page.dart';

void main() {
  runApp(ProductCategory());
}

class ProductCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artwork Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ArtworkGallery(categoryName: 'Pets Portraits'), // Replace with actual category name
    );
  }
}

class ArtworkGallery extends StatelessWidget {
  final String categoryName;

  ArtworkGallery({required this.categoryName});

  // Simulated product data
  final List<Map<String, dynamic>> products = [
    {"title": "Product 1", "imagePath": "assets/a1.jpg"},
    {"title": "Product 2", "imagePath": "assets/a2.jpg"},
    {"title": "Product 3", "imagePath": "assets/a3.jpg"},
    {"title": "Product 4", "imagePath": "assets/a1.jpg"},
    {"title": "Product 5", "imagePath": "assets/a2.jpg"},
    {"title": "Product 6", "imagePath": "assets/a3.jpg"},
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryName,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  'Filter',
                  style: TextStyle(color: Colors.black),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, color: Colors.black),
                  onSelected: (value) {
                    // Handle filter selection here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$value selected')),
                    );
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Media', 'Size', 'Price'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: Colors.blue,
            height: 2.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.8, // Adjusted aspect ratio for taller cards
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              String productTitle = products[index]["title"];
              String imagePath = products[index]["imagePath"];

              return _buildArtworkCard(context, productTitle, imagePath, index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildArtworkCard(BuildContext context, String productTitle, String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetialsPage()
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('See Details clicked')),
                        );
                      },
                      child: Text(
                        'See Details',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

