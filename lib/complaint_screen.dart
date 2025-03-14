import 'package:flutter/material.dart';
import 'package:acmhackthon/profile_of_student.dart';

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

  // Checkbox selections
  bool waterProblem = false;
  bool electricityProblem = false;
  bool wifiProblem = false;

  void submitComplaint() {
    if (_formKey.currentState!.validate()) {
      String complaintSummary =
          "🏠 Hostel: ${hostelController.text}\n🛏 Room: ${roomController.text}\n";

      if (waterProblem) complaintSummary += "💧 Water Supply Issue\n";
      if (electricityProblem) complaintSummary += "⚡ Electricity Issue\n";
      if (wifiProblem) complaintSummary += "📶 WiFi Issue\n";

      if (problemController.text.isNotEmpty) {
        complaintSummary += "📝 Additional: ${problemController.text}\n";
      }

      // Show Snackbar Confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Complaint Submitted Successfully!"),
          backgroundColor: Colors.purple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🏠 Hostel Complaint Form'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Center(
                  child: Text(
                    "Submit Your Complaint",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Hostel Name
                TextFormField(
                  controller: hostelController,
                  decoration: InputDecoration(
                    labelText: "🏠 Hostel Name",
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Enter hostel name" : null,
                ),
                SizedBox(height: 16),

                // Room Number
                TextFormField(
                  controller: roomController,
                  decoration: InputDecoration(
                    labelText: "🛏 Room Number",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? "Enter room number" : null,
                ),
                SizedBox(height: 16),

                // Common Problems (Checkboxes)
                Text(
                  "Common Problems:",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple),
                ),
                CheckboxListTile(
                  title: Text("💧 Water Supply Problem"),
                  value: waterProblem,
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    setState(() => waterProblem = value!);
                  },
                ),
                CheckboxListTile(
                  title: Text("⚡ Electricity Problem"),
                  value: electricityProblem,
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    setState(() => electricityProblem = value!);
                  },
                ),
                CheckboxListTile(
                  title: Text("📶 WiFi Problem"),
                  value: wifiProblem,
                  activeColor: Colors.purple,
                  onChanged: (value) {
                    setState(() => wifiProblem = value!);
                  },
                ),
                SizedBox(height: 16),

                // Additional Problem Description
                TextFormField(
                  controller: problemController,
                  decoration: InputDecoration(
                    labelText: "📝 Other Problems (Optional)",
                    hintText: "Describe your issue...",
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 20),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: submitComplaint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Submit Complaint",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
