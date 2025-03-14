import 'package:flutter/material.dart';
import 'package:acmhackthon/profile_of_student.dart';
import 'notifiction_for_student.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NestEase'),
        centerTitle: true,
        backgroundColor: Color(0xFF370740),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications , color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifictionForStudent()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person , color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileOfStudent()),
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
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(color: Color(0xFF370740)),
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
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'NestEase',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF370740),
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/hostelimage.jpg',
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30),
              Text(
                '"A well-managed hostel is not just a place to stay, \n it\'s a home away from home."',
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF370740),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF370740),
                ),
              ),
              SizedBox(height: 20),
              FAQItem(
                question: 'Hostel In Time',
                answer: 'The check-in time is 9:00 PM.',
              ),
              SizedBox(height: 20),
              FAQItem(
                question: 'Water Availability',
                answer: 'Water is available 24/7.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.purple[50],
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center text inside the container
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF370740),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF370740),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
