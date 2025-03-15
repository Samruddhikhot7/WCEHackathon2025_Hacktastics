import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  double totalAmount = 0.0;
  final double mealCost = 80.0; // ₹80 per meal

  @override
  void initState() {
    super.initState();
    _calculateTotalAmount();
  }

  /// Fetch meal selection data and calculate the total billing amount
  Future<void> _calculateTotalAmount() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userMeals = await FirebaseFirestore.instance
          .collection('mealSelections')
          .doc(userId)
          .get();

      if (userMeals.exists) {
        Map<String, dynamic> mealData = userMeals.data() as Map<String, dynamic>;

        // Filter out non-boolean values (like timestamp) before counting
        int consumedMealCount = mealData.entries
            .where((entry) => entry.value is bool && entry.value == true)
            .length;

        setState(() {
          totalAmount = consumedMealCount * mealCost;
        });
      }
    } catch (e) {
      print("Error fetching meal data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Billing',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          color: Colors.purple.shade50,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Total Amount", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple.shade900)),
                const SizedBox(height: 10),
                Text("₹${totalAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.purple)),
                const SizedBox(height: 20),
                QrImageView(data: "payment://pay?amount=$totalAmount", version: QrVersions.auto, size: 200.0, backgroundColor: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
