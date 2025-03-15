import 'package:flutter/material.dart';
import 'package:acmhackthon/permission_screen.dart';
import 'billing_screen.dart';
import 'complaint_screen.dart';
import 'food_menu_screen.dart';
import 'home_screen.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
          HomeScreen(),
          FoodMenuScreen(),
          PermissionScreen(),
          ComplaintScreen(),
          BillingScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Permission'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Complaint'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Billing'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
