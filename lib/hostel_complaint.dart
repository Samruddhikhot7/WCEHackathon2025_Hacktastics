import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_for_hostel.dart';

class HostelComplaint extends StatelessWidget {
  Stream<QuerySnapshot> getComplaintsStream() {
    return FirebaseFirestore.instance
        .collection('hostel_complaints')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void updateComplaintStatus(String docId, String newStatus) {
    FirebaseFirestore.instance
        .collection('hostel_complaints')
        .doc(docId)
        .update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationForHostel()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child:
              Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(color: Colors.purple),
            ),
            ListTile(
              title: Text('About Us'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getComplaintsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var complaints = snapshot.data!.docs;

          return complaints.isEmpty
              ? Center(child: Text("No complaints found!"))
              : ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              var complaint = complaints[index];
              var data = complaint.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: Colors.purple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "🏠 Hostel: ${data['hostel']}",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple),
                      ),
                      Text(
                        "🛏 Room: ${data['room']}",
                        style: TextStyle(fontSize: 16),
                      ),
                      if (data['waterProblem'])
                        Text("💧 Water Problem",
                            style:
                            TextStyle(fontSize: 16, color: Colors.red)),
                      if (data['electricityProblem'])
                        Text("⚡ Electricity Issue",
                            style:
                            TextStyle(fontSize: 16, color: Colors.red)),
                      if (data['wifiProblem'])
                        Text("📶 WiFi Issue",
                            style:
                            TextStyle(fontSize: 16, color: Colors.red)),
                      if (data['additionalProblem'] != '')
                        Text("📝 Additional: ${data['additionalProblem']}",
                            style: TextStyle(fontSize: 16)),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status: ${data['status']}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          DropdownButton<String>(
                            value: data['status'],
                            onChanged: (newValue) {
                              updateComplaintStatus(complaint.id, newValue!);
                            },
                            items: ['Pending', 'In Progress', 'Resolved']
                                .map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
