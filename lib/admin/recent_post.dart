import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecentPostScreen(),
    );
  }
}

class RecentPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Recent Posts')),
      ),
      body: PostsList(),
    );
  }
}

class PostsList extends StatefulWidget {
  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final CollectionReference _postsCollection =
  FirebaseFirestore.instance.collection('Posts');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postsCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error fetching posts'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No posts available'));
        }

        final posts = snapshot.data!.docs.map((doc) {
          return Post(
            title: doc['title'],
            mediaUrl: doc['image'],
            address: doc['address'],
            description: doc['description'],
          );
        }).toList();

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: buildPostCard(posts[index]),
            );
          },
        );
      },
    );
  }

  Widget buildPostCard(Post post) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Post Media (Image)
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              post.mediaUrl,
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          // Title of the Post
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              post.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Address Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Address:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  child: Text(
                    post.address,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // Related Text (Post Description)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              post.description,
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          // Edit and Delete Buttons
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Implement edit functionality
                  print('Edit button pressed for ${post.title}');
                },
                icon: Icon(Icons.edit),
                label: Text('Edit'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Implement delete functionality
                  print('Delete button pressed for ${post.title}');
                },
                icon: Icon(Icons.delete),
                label: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Post {
  final String title;
  final String mediaUrl;
  final String address;
  final String description;

  Post({
    required this.title,
    required this.mediaUrl,
    required this.address,
    required this.description,
  });
}
