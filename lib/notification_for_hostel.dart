import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationForHostel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications for Hostel'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notifications').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index].data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.all(8),
                child: ListTile(
                  leading: Icon(Icons.notifications, color: Colors.purple),
                  title: Text(notification['title'] ?? 'New Notification', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(notification['message'] ?? 'Complaint registered.'),
                  trailing: Text(notification['timestamp'] != null
                      ? DateTime.fromMillisecondsSinceEpoch(notification['timestamp'].seconds * 1000).toString()
                      : ''),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
