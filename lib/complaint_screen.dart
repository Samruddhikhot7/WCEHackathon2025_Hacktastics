import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notifiction_for_student.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  _ComplaintScreenState createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController hostelController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController problemController = TextEditingController();

  bool waterProblem = false;
  bool electricityProblem = false;
  bool wifiProblem = false;

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
  }

  // Request Notification Permission
  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
  }

  // Send Notification to Hostel Admin
  Future<void> sendNotificationToHostel(String complaintId) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': 'New Hostel Complaint',
      'message': 'Complaint Registered in ${hostelController.text}, Room ${roomController.text}',
      'timestamp': FieldValue.serverTimestamp(),
      'complaintId': complaintId,
    });
  }

  // Submit Complaint & Notify Admin
  void submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Create Complaint Data
      Map<String, dynamic> complaintData = {
        'userId': userId,
        'hostel': hostelController.text,
        'room': roomController.text,
        'waterProblem': waterProblem,
        'electricityProblem': electricityProblem,
        'wifiProblem': wifiProblem,
        'additionalProblem': problemController.text,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'Pending',
      };

      // Save Complaint to Firestore
      DocumentReference complaintRef =
      await FirebaseFirestore.instance.collection('hostel_complaints').add(complaintData);

      // Notify Hostel Admin
      await sendNotificationToHostel(complaintRef.id);

      // Show Success Message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Complaint Submitted & Admin Notified!"),
          backgroundColor: Colors.purple,
        ),
      );

      // Clear Form Fields
      hostelController.clear();
      roomController.clear();
      problemController.clear();
      setState(() {
        waterProblem = false;
        electricityProblem = false;
        wifiProblem = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🏠 Hostel Complaint Form'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Submit Your Complaint", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.purple)),
                SizedBox(height: 20),

                TextFormField(
                  controller: hostelController,
                  decoration: InputDecoration(labelText: "🏠 Hostel Name"),
                  validator: (value) => value!.isEmpty ? "Enter hostel name" : null,
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: roomController,
                  decoration: InputDecoration(labelText: "🛏 Room Number"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter room number" : null,
                ),
                SizedBox(height: 16),

                Text("Common Problems:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple)),
                CheckboxListTile(
                  title: Text("💧 Water Supply Problem"),
                  value: waterProblem,
                  activeColor: Colors.purple,
                  onChanged: (value) => setState(() => waterProblem = value!),
                ),
                CheckboxListTile(
                  title: Text("⚡ Electricity Problem"),
                  value: electricityProblem,
                  activeColor: Colors.purple,
                  onChanged: (value) => setState(() => electricityProblem = value!),
                ),
                CheckboxListTile(
                  title: Text("📶 WiFi Problem"),
                  value: wifiProblem,
                  activeColor: Colors.purple,
                  onChanged: (value) => setState(() => wifiProblem = value!),
                ),
                SizedBox(height: 16),

                TextFormField(
                  controller: problemController,
                  decoration: InputDecoration(labelText: "📝 Other Problems (Optional)", hintText: "Describe your issue..."),
                  maxLines: 3,
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: submitComplaint,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12)),
                  child: Text("Submit Complaint", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
