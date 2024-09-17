import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Products'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: <Widget>[
            AdImageSlider(), // Separate widget for the image slider
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCategorySection('Cat'), // Display data for 'Cat' category
                      _buildCategorySection('Family'), // Display data for 'Family' category
                      _buildCategorySection('Stylish'), // Display data for 'Stylish' category
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('images')
              .where('category', isEqualTo: category)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            }

            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Text('No data available');
            }

            return Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return _buildProductItem(data);
              }).toList(),
            );
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildProductItem(Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(data: data),
          ),
        );
      },
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              data['imageUrl'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(
            data['name'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class AdImageSlider extends StatefulWidget {
  @override
  _AdImageSliderState createState() => _AdImageSliderState();
}

class _AdImageSliderState extends State<AdImageSlider> {
  List<String> adImages = [
    'assets/a1.jpg',
    'assets/a2.jpg',
    'assets/a3.jpg',
  ];
  int _currentImageIndex = 0;
  Timer? _timer;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _startImageSlider();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startImageSlider() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_currentImageIndex < adImages.length - 1) {
        _currentImageIndex++;
      } else {
        _currentImageIndex = 0;
      }
      _pageController.animateToPage(
        _currentImageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: 150, // Adjust height as needed
        child: PageView.builder(
          controller: _pageController,
          itemCount: adImages.length,
          itemBuilder: (context, index) {
            return Image.asset(
              adImages[index],
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  ProductDetailScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              data['imageUrl'],
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Text(
              'Description: ${data['description']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Price: \$${data['price']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
