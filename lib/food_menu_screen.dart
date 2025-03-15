import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodMenuScreen extends StatefulWidget {
  @override
  _FoodMenuScreenState createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {
  bool breakfast = false;
  bool lunch = false;
  bool dinner = false;

  void _submitMealSelection() async {
    String userId = FirebaseAuth.instance.currentUser!.uid; // Get logged-in student ID

    await FirebaseFirestore.instance.collection('mealSelections').doc(userId).set({
      'breakfast': breakfast,
      'lunch': lunch,
      'dinner': dinner,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Meal selection submitted!"),
        backgroundColor: Colors.purple.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Meal Selection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            MealSelection(mealName: 'Breakfast', value: breakfast, onChanged: (val) => setState(() => breakfast = val!)),
            SizedBox(height: 15),
            MealSelection(mealName: 'Lunch', value: lunch, onChanged: (val) => setState(() => lunch = val!)),
            SizedBox(height: 15),
            MealSelection(mealName: 'Dinner', value: dinner, onChanged: (val) => setState(() => dinner = val!)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submitMealSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

class MealSelection extends StatelessWidget {
  final String mealName;
  final bool value;
  final ValueChanged<bool?> onChanged;

  MealSelection({required this.mealName, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              mealName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.purple.shade900),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}