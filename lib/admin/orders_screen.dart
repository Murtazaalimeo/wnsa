import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = FirestoreService().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('OrdersScreen')),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            List<User> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return ExpansionTile(
                  title: Text(user.fullName),
                  subtitle: Text(user.email),
                  children: user.purchases.map((purchase) {
                    return ListTile(
                      title: Text(purchase.artworkTitle),
                      subtitle: Text('Amount: \$${purchase.amount.toString()}'),
                      trailing: Text(purchase.paymentComplete ? 'Paid' : 'Unpaid'),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class User {
  String email;
  String phone;
  String fullName;
  String address;
  List<Purchase> purchases;

  User({
    required this.email,
    required this.phone,
    required this.fullName,
    required this.address,
    required this.purchases,
  });

  factory User.fromMap(Map<String, dynamic> data, List<Purchase> purchases) {
    return User(
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      fullName: data['fullName']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      purchases: purchases,
    );
  }
}

class Purchase {
  double amount;
  String artworkId;
  String artworkTitle;
  bool paymentComplete;
  String purchaseNumber;
  DateTime timeStamp;

  Purchase({
    required this.amount,
    required this.artworkId,
    required this.artworkTitle,
    required this.paymentComplete,
    required this.purchaseNumber,
    required this.timeStamp,
  });

  factory Purchase.fromMap(Map<String, dynamic> data) {
    return Purchase(
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      artworkId: data['artworkId']?.toString() ?? '',
      artworkTitle: data['artworkTitle']?.toString() ?? '',
      paymentComplete: data['paymentComplete'] as bool? ?? false,
      purchaseNumber: data['purchaseNumber']?.toString() ?? '',
      timeStamp: (data['timeStamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<User>> fetchUsers() async {
    QuerySnapshot userSnapshot = await _db.collection('users').get();
    List<User> users = [];
    for (var userDoc in userSnapshot.docs) {
      List<Purchase> purchases = await fetchPurchases(userDoc.id);
      users.add(User.fromMap(userDoc.data() as Map<String, dynamic>, purchases));
    }
    return users;
  }

  Future<List<Purchase>> fetchPurchases(String userId) async {
    QuerySnapshot purchaseSnapshot = await _db.collection('users').doc(userId).collection('purchases').get();
    return purchaseSnapshot.docs.map((doc) => Purchase.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}
