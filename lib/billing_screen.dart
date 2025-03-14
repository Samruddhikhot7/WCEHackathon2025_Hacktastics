import 'package:flutter/material.dart';
import 'package:acmhackthon/profile_of_student.dart';

import 'notifiction_for_student.dart';

class BillingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Billing'),
        centerTitle: true,
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
      body: Center(child: Text('Billing Page')),
    );
  }
}
