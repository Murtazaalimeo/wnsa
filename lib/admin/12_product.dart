import 'package:flutter/material.dart';


class ArtworkGallery extends StatelessWidget {
  final String categoryName;

  ArtworkGallery({required this.categoryName});

  // Simulated product data using the first three images repeatedly to create 12 products
  final List<Map<String, dynamic>> products = List.generate(12, (index) {
    return {
      "title": "Product ${index + 1}",
      "imagePath": "assets/a${(index % 3) + 1}.jpg"
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7, // Adjusted aspect ratio for the cards
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          String productTitle = products[index]["title"];
          String imagePath = products[index]["imagePath"];

          return _buildArtworkCard(context, productTitle, imagePath, index);
        },
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
            builder: (context) => ProductDetailsPage(productTitle: productTitle, imagePath: imagePath),
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    productTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductDetailsPage extends StatelessWidget {
  final String productTitle;
  final String imagePath;

  ProductDetailsPage({required this.productTitle, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productTitle),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              productTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to gallery
              },
              child: Text('Back to Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}
