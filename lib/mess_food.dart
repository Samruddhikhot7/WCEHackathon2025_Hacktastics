import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'notification_for_mess.dart';

class MessFood extends StatefulWidget {
  @override
  _FoodMenuScreenState createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<MessFood> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Menu'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationForMess()),
              );
              // Handle notification action
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
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date:', style: TextStyle(fontSize: 18, color: Colors.purple)),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  hintText: 'Pick a date',
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.purple),
                ),
              ),
              SizedBox(height: 20),
              Text('Breakfast Menu:', style: TextStyle(fontSize: 18, color: Colors.purple)),
              TextFormField(
                controller: _breakfastController,
                decoration: InputDecoration(hintText: 'Enter breakfast menu'),
                maxLines: 1,
              ),
              SizedBox(height: 20),
              Text('Lunch Menu:', style: TextStyle(fontSize: 18, color: Colors.purple)),
              TextFormField(
                controller: _lunchController,
                decoration: InputDecoration(hintText: 'Enter lunch menu'),
                maxLines: 1,
              ),
              SizedBox(height: 20),
              Text('Dinner Menu:', style: TextStyle(fontSize: 18, color: Colors.purple)),
              TextFormField(
                controller: _dinnerController,
                decoration: InputDecoration(hintText: 'Enter dinner menu'),
                maxLines: 1,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_dateController.text.isNotEmpty &&
                        _breakfastController.text.isNotEmpty &&
                        _lunchController.text.isNotEmpty &&
                        _dinnerController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Form Submitted'),
                            content: Text(
                                'Date: ${_dateController.text}\nBreakfast: ${_breakfastController.text}\nLunch: ${_lunchController.text}\nDinner: ${_dinnerController.text}'),
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
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}