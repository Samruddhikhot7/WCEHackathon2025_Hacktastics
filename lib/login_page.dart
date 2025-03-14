import 'package:flutter/material.dart';
import 'signup_page.dart';
import 'admin_dashboard.dart';
import 'student_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedRole = "";

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (selectedRole == "Admin") {
        if (usernameController.text == "admin" && passwordController.text == "admin123") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Admin Credentials")));
        }
      } else if (selectedRole == "Student") {
        if (usernameController.text == "student" && passwordController.text == "student123") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid Student Credentials")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select a role")));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome To\nNestEase",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                ),
                SizedBox(height: 30),

                // Role Selection
                ElevatedButton(
                  onPressed: () => setState(() => selectedRole = "Student"),
                  child: Text("STUDENT", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRole == "Student" ? Colors.blue : Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => setState(() => selectedRole = "Admin"),
                  child: Text("ADMIN", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRole == "Admin" ? Colors.blue : Colors.grey.shade300,
                  ),
                ),
                SizedBox(height: 15),

                // Username
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: "Username"),
                  validator: (value) => value!.isEmpty ? "Enter username" : null,
                ),
                SizedBox(height: 15),

                // Password
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                  validator: (value) => value!.length < 6 ? "Password must be 6+ chars" : null,
                ),
                SizedBox(height: 15),

                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  child: Text("LOGIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 15),

                // Sign Up Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text("Sign Up", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
