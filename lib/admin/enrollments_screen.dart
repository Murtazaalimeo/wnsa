import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({super.key});

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
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
                  children: user.enrollments.map((enrollment) {
                    return ListTile(
                      title: Text(enrollment.courseTitle),
                      subtitle: Text('Amount: \$${enrollment.amount.toString()}'),
                      trailing: Text(enrollment.paymentComplete ? 'Paid' : 'Unpaid'),
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
  List<Enrollment> enrollments;

  User({
    required this.email,
    required this.phone,
    required this.fullName,
    required this.address,
    required this.enrollments,
  });

  factory User.fromMap(Map<String, dynamic> data, List<Enrollment> enrollments) {
    return User(
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString() ?? '',
      fullName: data['fullName']?.toString() ?? '',
      address: data['address']?.toString() ?? '',
      enrollments: enrollments,
    );
  }
}

class Enrollment {
  double amount;
  String courseId;
  String courseTitle;
  bool paymentComplete;
  String enrollmentNumber;
  DateTime timeStamp;

  Enrollment({
    required this.amount,
    required this.courseId,
    required this.courseTitle,
    required this.paymentComplete,
    required this.enrollmentNumber,
    required this.timeStamp,
  });

  factory Enrollment.fromMap(Map<String, dynamic> data) {
    return Enrollment(
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      courseId: data['courseId']?.toString() ?? '',
      courseTitle: data['courseTitle']?.toString() ?? '',
      paymentComplete: data['paymentComplete'] as bool? ?? false,
      enrollmentNumber: data['enrollmentNumber']?.toString() ?? '',
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
      List<Enrollment> enrollments = await fetchEnrollments(userDoc.id);
      users.add(User.fromMap(userDoc.data() as Map<String, dynamic>, enrollments));
    }
    return users;
  }

  Future<List<Enrollment>> fetchEnrollments(String userId) async {
    QuerySnapshot enrollmentSnapshot = await _db.collection('users').doc(userId).collection('enrollment').get();
    return enrollmentSnapshot.docs.map((doc) => Enrollment.fromMap(doc.data() as Map<String, dynamic>)).toList();
  }
}
