// breakfast_lunch_dinner_screen.dart
import 'package:flutter/material.dart';
import 'package:acmhackthon/profile_of_student.dart';

import 'notifiction_for_student.dart';

class FoodMenuScreen extends StatefulWidget {
  @override
  _BreakfastLunchDinnerScreenState createState() =>
      _BreakfastLunchDinnerScreenState();
}

class _BreakfastLunchDinnerScreenState extends State<FoodMenuScreen> {
  bool breakfast = false; // Default is "No"
  bool lunch = false; // Default is "No"
  bool dinner = false; // Default is "No"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Selection for Tomorrow'),centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifictionForStudent()),
              );
              // Handle notification action
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileOfStudent()),
              );// Handle profile action
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(
                color: Colors.purple,
              ),
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () {
                // Handle About Us action
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Handle Log Out action
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                // Handle Log Out action
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select your meal',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 20),
            MealSelection(
              mealName: 'Breakfast',
              value: breakfast,
              onChanged: (value) {
                setState(() {
                  breakfast = value!;
                });
              },
            ),
            MealSelection(
              mealName: 'Lunch',
              value: lunch,
              onChanged: (value) {
                setState(() {
                  lunch = value!;
                });
              },
            ),
            MealSelection(
              mealName: 'Dinner',
              value: dinner,
              onChanged: (value) {
                setState(() {
                  dinner = value!;
                });
              },
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Selection Summary'),
                      content: Text(
                        'Breakfast: ${breakfast ? "Yes" : "No"}\n'
                            'Lunch: ${lunch ? "Yes" : "No"}\n'
                            'Dinner: ${dinner ? "Yes" : "No"}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text('Submit'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
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

  MealSelection({
    required this.mealName,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          mealName,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Row(
          children: [
            Text('No'),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.purple,
            ),
            Text('Yes'),
          ],
        ),
      ],
    );
  }
}

