import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessFood extends StatefulWidget {
  @override
  _MessFoodState createState() => _MessFoodState();
}

class _MessFoodState extends State<MessFood> {
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
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  void _submitMeal() async {
    if (_dateController.text.isNotEmpty &&
        _breakfastController.text.isNotEmpty &&
        _lunchController.text.isNotEmpty &&
        _dinnerController.text.isNotEmpty) {
      // Save meal details to Firestore
      await FirebaseFirestore.instance.collection("mess_meals").add({
        "date": _dateController.text,
        "breakfast": _breakfastController.text,
        "lunch": _lunchController.text,
        "dinner": _dinnerController.text,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Save notification in Firestore
      await FirebaseFirestore.instance.collection("notifications").add({
        "title": "Meal Registered",
        "message":
        "Meals for ${_dateController.text} have been successfully registered.",
        "timestamp": FieldValue.serverTimestamp(),
      });

      // Show success message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Meal registered successfully!'),
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
      // Show error if any field is empty
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Text('Mess Food'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Date:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
              SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Pick a date',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.purple),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField('Breakfast Menu', _breakfastController),
              _buildTextField('Lunch Menu', _lunchController),
              _buildTextField('Dinner Menu', _dinnerController),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitMeal,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Enter $label',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
