import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:wnsa/auth/login.dart';
import 'package:wnsa/user2/user/product_category.dart';
import 'artdetail.dart';

class ArtworkGallery extends StatelessWidget {
  final List<String> assetImages = [
    'assets/a1.jpg',
    'assets/a2.jpg',
    'assets/a3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gallery',
          style: TextStyle(fontWeight: FontWeight.bold), // Bold title
        ),
        backgroundColor: Colors.white, // Changed app bar color to white
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collectionGroup('Products').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot> products = snapshot.data!.docs;
          Map<String, List<DocumentSnapshot>> categoryMap = {};

          for (var product in products) {
            String category = product.reference.parent.parent!.id;
            if (!categoryMap.containsKey(category)) {
              categoryMap[category] = [];
            }
            categoryMap[category]!.add(product);
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCarouselSection(context, assetImages),
                SizedBox(height: 20),
                ...categoryMap.keys.map((category) =>
                    _buildCategorySection(context, category, categoryMap[category]!)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCarouselSection(BuildContext context, List<String> images) {
    double carouselHeight = MediaQuery.of(context).size.height * 0.3;

    return Container(
      height: carouselHeight,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          height: carouselHeight,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.9, // Adjusted to show more of the third image
        ),
        items: images.map((image) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String categoryName, List<DocumentSnapshot> products) {
    double rowHeight = MediaQuery.of(context).size.height * 0.25;
    double cardWidth = MediaQuery.of(context).size.width * 0.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(category: categoryName),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: rowHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              String productTitle = products[index]["mediaType"];
              String imagePath = products[index]["image"];
              return Padding(
                padding: EdgeInsets.only(left: index == 0 ? 16.0 : 4.0, right: index == products.length - 1 ? 16.0 : 0),
                child: _buildArtworkCard(context, productTitle, imagePath, rowHeight, cardWidth, products[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtworkCard(BuildContext context, String productTitle, String imagePath, double cardHeight, double cardWidth, DocumentSnapshot product) {
    return Container(
      width: cardWidth,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ArtworkDetailScreen(product: product)),
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
              height: cardHeight,
              width: cardWidth,
            ),
          ),
        ),
      ),
    );
  }
}

class ShoppingCartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: Center(
        child: Text('Shopping Cart Screen'),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Center(
        child: Text('Favorites Screen'),
      ),
    );
  }
}
