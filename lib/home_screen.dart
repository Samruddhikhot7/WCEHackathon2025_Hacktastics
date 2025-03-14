import 'package:flutter/material.dart';
import 'package:acmhackthon/profile_of_student.dart';
import 'notifiction_for_student.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NestEase',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF370740),
        elevation: 6,
        shadowColor: Colors.black26,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotifictionForStudent()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileOfStudent()),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF370740)),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            _buildDrawerItem(context, Icons.info, 'About Us'),
            _buildDrawerItem(context, Icons.settings, 'Settings'),
            _buildDrawerItem(context, Icons.exit_to_app, 'Log Out'),
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
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF370740),
                  letterSpacing: 2.0,
                ),
              ),
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/hostelimage.jpg',
                  width: 320,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.0),
                child: Text(
                  '"A well-managed hostel is not just a place to stay, it\'s a home away from home."',
                  style: TextStyle(
                    fontSize: 22,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF370740),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF370740),
                ),
              ),
              SizedBox(height: 20),
              FAQItem(question: 'Hostel In Time', answer: 'The check-in time is 9:00 PM.'),
              SizedBox(height: 15),
              FAQItem(question: 'Water Availability', answer: 'Water is available 24/7.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF370740)),
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(context),
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
      width: double.infinity,
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.purple[50],
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF370740),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            answer,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF370740),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}