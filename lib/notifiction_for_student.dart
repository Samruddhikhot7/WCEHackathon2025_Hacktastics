import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotifictionForStudent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications for Students'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("notifications")
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No meal notifications yet."));
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              var title = notification["title"];
              var message = notification["message"];
              var timestamp = notification["timestamp"] as Timestamp?;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message),
                      if (timestamp != null)
                        Text(
                          "Time: ${DateFormat('yyyy-MM-dd HH:mm').format(timestamp.toDate())}",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                    ],
                  ),
                  leading: Icon(Icons.notifications_active, color: Colors.purple),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
