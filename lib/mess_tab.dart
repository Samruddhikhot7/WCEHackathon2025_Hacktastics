import 'package:acmhackthon/mess_count.dart';
import 'package:flutter/material.dart';
import 'mess_food.dart';

class MessTab extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<MessTab> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MessFood(),
          MessCountScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'MessFood'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'MessCount'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white, // White color for selected icon & text
        unselectedItemColor: Colors.purple.shade200, // Light purple for unselected
        backgroundColor: Colors.purple.shade700, // Dark purple background
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Bold selected text
      ),
    );
  }
}
