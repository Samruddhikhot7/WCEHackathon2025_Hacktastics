import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:acmhackthon/profile_of_student.dart';

import 'notifiction_for_student.dart';

class PermissionScreen extends StatefulWidget {
  @override
  _PermissionScreenState createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _yearBranchController = TextEditingController();
  final TextEditingController _rollNumberController = TextEditingController();
  final TextEditingController _hostelNameController = TextEditingController();
  final TextEditingController _roomNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _parentsNumberController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _outDateController = TextEditingController();
  final TextEditingController _inDateController = TextEditingController();

  DateTime _outDate = DateTime.now();
  DateTime _inDate = DateTime.now();

  // Date Picker for Out Date
  Future<void> _selectOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _outDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _outDate = picked;
        _outDateController.text = DateFormat('yyyy-MM-dd').format(_outDate);
      });
    }
  }

  // Date Picker for In Date
  Future<void> _selectInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _inDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _inDate = picked;
        _inDateController.text = DateFormat('yyyy-MM-dd').format(_inDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Permission Request'),
        backgroundColor: Colors.purple,
        centerTitle: true,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField('Student Name', _studentNameController),
              buildTextField('Year & Branch', _yearBranchController),
              buildTextField('Roll Number', _rollNumberController),
              buildTextField('Hostel Name', _hostelNameController),
              buildTextField('Room Number', _roomNumberController),
              buildTextField('Phone Number', _phoneNumberController, keyboardType: TextInputType.phone),
              buildTextField('Parent\'s Phone Number', _parentsNumberController, keyboardType: TextInputType.phone),
              buildTextField('Address', _addressController, maxLines: 3),
              buildTextField('Reason for Permission', _reasonController, maxLines: 3),

              // Out Date
              buildDateField('Out Date', _outDateController, () => _selectOutDate(context)),

              // In Date
              buildDateField('In Date', _inDateController, () => _selectInDate(context)),

              SizedBox(height: 20),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, color: Colors.purple)),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: 'Enter $label'),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildDateField(String label, TextEditingController controller, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, color: Colors.purple)),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: 'Pick $label',
            suffixIcon: Icon(Icons.calendar_today, color: Colors.purple),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _handleSubmit() {
    if (_studentNameController.text.isNotEmpty &&
        _yearBranchController.text.isNotEmpty &&
        _rollNumberController.text.isNotEmpty &&
        _hostelNameController.text.isNotEmpty &&
        _roomNumberController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty &&
        _parentsNumberController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _reasonController.text.isNotEmpty &&
        _outDateController.text.isNotEmpty &&
        _inDateController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permission Submitted'),
            content: Text(
              'Student Name: ${_studentNameController.text}\n'
                  'Year & Branch: ${_yearBranchController.text}\n'
                  'Roll Number: ${_rollNumberController.text}\n'
                  'Hostel Name: ${_hostelNameController.text}\n'
                  'Room Number: ${_roomNumberController.text}\n'
                  'Phone Number: ${_phoneNumberController.text}\n'
                  'Parent\'s Phone Number: ${_parentsNumberController.text}\n'
                  'Address: ${_addressController.text}\n'
                  'Reason: ${_reasonController.text}\n'
                  'Out Date: ${_outDateController.text}\n'
                  'In Date: ${_inDateController.text}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill out all fields.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
