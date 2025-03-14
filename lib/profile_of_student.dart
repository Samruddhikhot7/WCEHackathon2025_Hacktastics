import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'notifiction_for_student.dart';

class ProfileOfStudent extends StatefulWidget {
  @override
  _ProfileOfStudentState createState() => _ProfileOfStudentState();
}

class _ProfileOfStudentState extends State<ProfileOfStudent> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController hostelController = TextEditingController();
  TextEditingController roomController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();

  String? profileImageUrl;
  bool isEditing = false;
  bool isLoading = true;

  final ImagePicker _picker = ImagePicker();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile();
  }

  Future<void> _fetchStudentProfile() async {
    if (user != null) {
      DocumentSnapshot profileSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(user!.uid)
          .get();

      if (profileSnapshot.exists) {
        var data = profileSnapshot.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['name'] ?? '';
          contactController.text = data['contact'] ?? '';
          hostelController.text = data['hostel'] ?? '';
          roomController.text = data['room'] ?? '';
          homeAddressController.text = data['homeAddress'] ?? '';
          profileImageUrl = data['profileImage'] ?? null;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _uploadProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pictures/${user!.uid}.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        profileImageUrl = imageUrl;
      });

      FirebaseFirestore.instance
          .collection('students')
          .doc(user!.uid)
          .update({'profileImage': imageUrl});
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('students').doc(user!.uid).set({
        'name': nameController.text,
        'contact': contactController.text,
        'hostel': hostelController.text,
        'room': roomController.text,
        'homeAddress': homeAddressController.text,
        'profileImage': profileImageUrl ?? '',
      });

      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profile Updated Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile of Student'),
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
              decoration: BoxDecoration(color: Colors.purple),
            ),
            ListTile(title: Text('About Us'), onTap: () => Navigator.pop(context)),
            ListTile(title: Text('Settings'), onTap: () => Navigator.pop(context)),
            ListTile(title: Text('Log Out'), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Picture
                GestureDetector(
                  onTap: isEditing ? _uploadProfilePicture : null,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : AssetImage('assets/default_profile.png')
                    as ImageProvider,
                    child: isEditing
                        ? Icon(Icons.camera_alt, size: 30, color: Colors.white70)
                        : null,
                  ),
                ),
                SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: nameController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "👤 Name"),
                  validator: (value) => value!.isEmpty ? "Enter your name" : null,
                ),
                SizedBox(height: 10),

                // Contact Field
                TextFormField(
                  controller: contactController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "📞 Contact Number"),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                  value!.isEmpty ? "Enter your contact number" : null,
                ),
                SizedBox(height: 10),

                // Hostel Name
                TextFormField(
                  controller: hostelController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "🏠 Hostel Name"),
                  validator: (value) =>
                  value!.isEmpty ? "Enter hostel name" : null,
                ),
                SizedBox(height: 10),

                // Room Number
                TextFormField(
                  controller: roomController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "🛏 Room Number"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? "Enter room number" : null,
                ),
                SizedBox(height: 10),

                // Home Address
                TextFormField(
                  controller: homeAddressController,
                  enabled: isEditing,
                  decoration: InputDecoration(labelText: "🏡 Home Address"),
                  maxLines: 2,
                  validator: (value) =>
                  value!.isEmpty ? "Enter home address" : null,
                ),
                SizedBox(height: 20),

                // Edit / Save Button
                isEditing
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Save", style: TextStyle(fontSize: 18)),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() => isEditing = false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text("Cancel", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                )
                    : ElevatedButton(
                  onPressed: () => setState(() => isEditing = true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Edit Profile", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
