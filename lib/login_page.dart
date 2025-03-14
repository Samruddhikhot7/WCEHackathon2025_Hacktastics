import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_page.dart';
import 'admin_dashboard.dart';
import 'student_dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedRole = "";

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      if (selectedRole == "Admin") {
        if (emailController.text == "admin" && passwordController.text == "admin123") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Invalid Admin Credentials"), backgroundColor: Colors.red),
          );
        }
      } else if (selectedRole == "Student") {
        try {
          await _auth.signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigation()));
        } on FirebaseAuthException catch (e) {
          String errorMessage = "Login failed";
          if (e.code == 'user-not-found') {
            errorMessage = "No user found with this email";
          } else if (e.code == 'wrong-password') {
            errorMessage = "Incorrect password";
          } else if (e.code == 'invalid-email') {
            errorMessage = "Invalid email format";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select a role"), backgroundColor: Colors.orange),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome To\nNestEase",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.purple.shade800),
                ),
                SizedBox(height: 30),

                // Role Selection
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRoleButton("Student"),
                    SizedBox(width: 10),
                    _buildRoleButton("Admin"),
                  ],
                ),
                SizedBox(height: 20),

                // Email Field
                _buildTextField(emailController, "Email", Icons.email),
                SizedBox(height: 15),

                // Password Field
                _buildTextField(passwordController, "Password", Icons.lock, obscureText: true),
                SizedBox(height: 20),

                // Login Button
                ElevatedButton(
                  onPressed: _login,
                  child: Text("LOGIN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(height: 15),

                // Sign Up Link
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.purple.shade700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role) {
    return ElevatedButton(
      onPressed: () => setState(() => selectedRole = role),
      child: Text(role, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedRole == role ? Colors.purple : Colors.grey.shade300,
        foregroundColor: selectedRole == role ? Colors.white : Colors.black,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.purple.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: Colors.purple),
      ),
      validator: (value) {
        if (value!.isEmpty) return "Enter $label";
        if (label == "Password" && value.length < 6) return "Password must be at least 6 characters";
        return null;
      },
    );
  }
}