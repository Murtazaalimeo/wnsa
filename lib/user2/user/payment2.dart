import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class Payment2 extends StatefulWidget {
  final double totalAmount;
  final String userId;
  final String artId;
  final String artTitle;

  const Payment2({
    Key? key,
    required this.totalAmount,
    required this.userId,
    required this.artId,
    required this.artTitle,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment2> {
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.deepPurple[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Artwork: ${widget.artTitle}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Total Amount: \$${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  await makePayment();
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      // Create Payment Intent on Stripe Server
      paymentIntentData =
      await createPaymentIntent(widget.totalAmount.toString(), 'USD');
      // Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customFlow: true,
          merchantDisplayName: 'Your Merchant Name',
        ),
      );
      // Display Payment Sheet
      displayPaymentSheet();
    } catch (e, s) {
      print('Payment exception:$e$s');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment failed")),
      );
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // Update Payment Status in Firestore
      await _updatePaymentStatusInFirestore();
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful")),
      );
      paymentIntentData = null;
    } on StripeException catch (e) {
      print('StripeException: $e');
      showDialog(
        context: context,
        builder: (_) =>
        const AlertDialog(
          content: Text("Payment cancelled"),
        ),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(String amount,
      String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51OghVGJKM7tbgReCOUQ4rrZhieIf8qR0MHaiMmCsWvlbiWm8jFh8xWYtuRD04stV3DDuoYLCgCpm7rqSVnplP7GD00mGpLwiLe',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create payment intent: ${response.body}');
        return Future.error('Failed to create payment intent');
      }
    } catch (err) {
      print('Error charging user: ${err.toString()}');
      return Future.error('Error charging user');
    }
  }

  String calculateAmount(String amount) {
    final a = (double.parse(amount) * 100).toInt();
    return a.toString();
  }

  Future<void> _updatePaymentStatusInFirestore() async {
    try {
      // Get the current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User is not logged in");

      String userEmail = user.email!;

      // Reference to the user's document
      DocumentReference userDocRef = FirebaseFirestore.instance.collection(
          'users').doc(userEmail);

      // Reference to the purchases collection inside the user's document
      CollectionReference purchasesCollection = userDocRef.collection(
          'purchases');

      // Get the count of current purchases
      QuerySnapshot purchasesSnapshot = await purchasesCollection.get();
      int purchaseCount = purchasesSnapshot.docs.length + 1; // Increment count

      // Add new purchase entry
      await purchasesCollection.add({
        'purchaseNumber': purchaseCount,
        'artworkId': widget.artId,
        'artworkTitle': widget.artTitle,
        'amount': widget.totalAmount,
        'paymentComplete': true,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Optionally, update the user's document with the latest purchase details
      // await userDocRef.update({
      //   'lastPurchase': {
      //     'purchaseNumber': purchaseCount,
      //     'artworkId': widget.artId,
      //     'artworkTitle': widget.artTitle,
      //     'amount': widget.totalAmount,
      //     'paymentComplete': true,
      //     'timestamp': FieldValue.serverTimestamp(),
      //   }
      // });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment successful")),
      );
    } catch (e) {
      print('Firestore error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred")),
      );
    }
  }
}