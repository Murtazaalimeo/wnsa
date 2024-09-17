import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artwork Detail Prototype',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomerArtworkDetailPage(),
    );
  }
}

class CustomerArtworkDetailPage extends StatelessWidget {
  // Placeholder data (replace with actual data fetching logic)
  final String imageSize = '24" x 36"';
  final String price = '\$500';
  final String media = 'Oil on Canvas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artwork Detail'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/a1.jpg', // Placeholder image from assets
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Media:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              media, // Placeholder media
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Size:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              imageSize, // Placeholder size
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Price:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              price, // Placeholder price
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 32.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for Purchase functionality
                    print('Purchase button clicked');
                  },
                  child: Text('Purchase'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Placeholder for Custom Order functionality
                    print('Custom Order button clicked');
                  },
                  child: Text('Custom Order'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
