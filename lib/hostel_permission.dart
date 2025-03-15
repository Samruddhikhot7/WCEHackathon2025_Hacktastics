import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_for_hostel.dart';

class HostelPermission extends StatelessWidget {
  Future<void> _updateStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection("permissions").doc(docId).update({
        "status": newStatus,
      });

      print("Status updated to $newStatus");
    } catch (e) {
      print("Error updating status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Permission Requests',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationForHostel()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple.shade700),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildDrawerItem(Icons.info, "About Us"),
            _buildDrawerItem(Icons.settings, "Settings"),
            _buildDrawerItem(Icons.logout, "Log Out"),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("permissions")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.purple));
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading data", style: TextStyle(color: Colors.red)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No permission requests found", style: TextStyle(color: Colors.black54)));
          }

          return ListView(
            padding: EdgeInsets.all(10),
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildText("${data['studentName']} - ${data['status']}", 18, true),
                      Divider(color: Colors.purple.shade300),
                      _buildText("🏠 Hostel: ${data['hostelName']}", 16, false),
                      _buildText("🛏 Room No: ${data['roomNo']}", 16, false),
                      _buildText("📍 Address: ${data['address']}", 16, false),
                      _buildText("📄 Reason: ${data['reason']}", 16, false),
                      _buildText("📅 From: ${data['fromDate']} - To: ${data['toDate']}", 16, false),
                      SizedBox(height: 10),
                      if (data['status'] == "Pending")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildActionButton("Approve", Colors.green, () => _updateStatus(doc.id, "Approved")),
                            SizedBox(width: 10),
                            _buildActionButton("Reject", Colors.red, () => _updateStatus(doc.id, "Rejected")),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      onTap: () {},
    );
  }

  Widget _buildText(String text, double fontSize, bool bold) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}