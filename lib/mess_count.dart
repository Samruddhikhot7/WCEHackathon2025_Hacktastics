import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessCountScreen extends StatefulWidget {
  @override
  _MessCountScreenState createState() => _MessCountScreenState();
}

class _MessCountScreenState extends State<MessCountScreen> {
  int breakfastYes = 0;
  int lunchYes = 0;
  int dinnerYes = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMealCounts();
  }

  Future<void> _fetchMealCounts() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('mealSelections').get();

    int breakfastCount = 0, lunchCount = 0, dinnerCount = 0;

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data['breakfast'] == true) breakfastCount++;
      if (data['lunch'] == true) lunchCount++;
      if (data['dinner'] == true) dinnerCount++;
    }

    setState(() {
      breakfastYes = breakfastCount;
      lunchYes = lunchCount;
      dinnerYes = dinnerCount;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mess Count', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 4,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.purple))
          : Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            MealCountCard(mealName: "Breakfast", count: breakfastYes, icon: Icons.free_breakfast),
            SizedBox(height: 15),
            MealCountCard(mealName: "Lunch", count: lunchYes, icon: Icons.lunch_dining),
            SizedBox(height: 15),
            MealCountCard(mealName: "Dinner", count: dinnerYes, icon: Icons.dinner_dining),
          ],
        ),
      ),
    );
  }
}

class MealCountCard extends StatelessWidget {
  final String mealName;
  final int count;
  final IconData icon;

  MealCountCard({required this.mealName, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.purple.shade700, size: 28),
                SizedBox(width: 12),
                Text(
                  mealName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.purple.shade900),
                ),
              ],
            ),
            Text(
              "$count students",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
            ),
          ],
        ),
      ),
    );
  }
}