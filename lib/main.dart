
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:wnsa/adminHome.dart';
import 'package:wnsa/user/usernav.dart';
import 'package:wnsa/user2/user/user_default.dart';
import 'auth/login.dart';
import 'auth/register.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='pk_test_51OghVGJKM7tbgReCU1dHECP2ci2UgORwGgFKMkD9iDYMug9zHYk077RwdLI7BZghMNFeCuKgKCBzpdZ1VCJaDn4U00foNz7GFN';
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AuthCheck(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/userHome': (context) => home(),
        '/adminHome': (context) => AdminScreen(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          final user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('roles').doc(user.email).get(),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              if (roleSnapshot.hasData) {
                final roleData = roleSnapshot.data!.data() as Map<String, dynamic>?;
                if (roleData != null && roleData['role'] == 'Admin') {
                  return AdminScreen();
                } else {
                  return MainScreen();
                }
              }
              return LoginScreen();
            },
          );
        }
        return LoginScreen();
      },
    );
  }
}

