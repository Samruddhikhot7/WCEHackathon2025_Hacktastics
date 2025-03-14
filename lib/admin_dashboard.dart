import 'package:flutter/material.dart';
import 'mess_tab.dart';
import 'hostel_tab.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessTab()),
                );
              },
              child: Text("Mess"),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HostelTab()),
                );
              },
              child: Text("Hostel"),
            ),
          ],
        ),
      ),
    );
  }
}
