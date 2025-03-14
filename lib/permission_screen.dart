import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController hostelController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
  }

  Future<void> _submitPermissionRequest() async {
    String fromDateText = fromDateController.text.trim();
    String toDateText = toDateController.text.trim();

    if (reasonController.text.isEmpty ||
        hostelController.text.isEmpty ||
        roomController.text.isEmpty ||
        addressController.text.isEmpty ||
        fromDateText.isEmpty ||
        toDateText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields with valid dates (dd-MM-yyyy)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection("permissions").add({
        "studentId": user.uid,
        "studentName": user.displayName ?? "Unknown",
        "hostelName": hostelController.text.trim(),
        "roomNo": roomController.text.trim(),
        "address": addressController.text.trim(),
        "reason": reasonController.text.trim(),
        "fromDate": fromDateText,
        "toDate": toDateText,
        "status": "Pending",
        "timestamp": FieldValue.serverTimestamp(),
      });

      await _sendNotificationToHostel(user.displayName ?? "A student");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Permission request submitted!"),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        reasonController.clear();
        hostelController.clear();
        roomController.clear();
        addressController.clear();
        fromDateController.clear();
        toDateController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit request"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _sendNotificationToHostel(String studentName) async {
    try {
      await FirebaseFirestore.instance.collection("notifications").add({
        "title": "New Permission Request",
        "message": "$studentName has requested hostel leave.",
        "timestamp": FieldValue.serverTimestamp(),
      });

      await _firebaseMessaging.subscribeToTopic("hostel_notifications");
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Request Permission"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(hostelController, "Hostel Name"),
            _buildTextField(roomController, "Room Number"),
            _buildTextField(addressController, "Address"),
            _buildTextField(reasonController, "Reason"),
            SizedBox(height: 10),

            _buildManualDateField(fromDateController, "From Date (dd-MM-yyyy)"),
            SizedBox(height: 10),
            _buildManualDateField(toDateController, "To Date (dd-MM-yyyy)"),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPermissionRequest,
              child: Text("Submit Request", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.purple.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildManualDateField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: label,
          hintText: "dd-MM-yyyy",
          filled: true,
          fillColor: Colors.purple.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
