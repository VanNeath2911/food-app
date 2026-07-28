// ignore_for_file: must_be_immutable, unused_field, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/main.dart';
import 'package:food_app/history/orderhistory.dart';
import 'package:food_app/widget/navigationbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountPage extends StatefulWidget {
  String userId;
  AccountPage({super.key, required this.userId});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _image;
  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });

    try {
      final ref = FirebaseStorage.instance.ref().child("profile_images").child("${widget.userId}.jpg");

      await ref.putFile(_image!);

      String url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection("collection_credential").doc(widget.userId).update({"photoUrl": url});
    } catch (e) {
      debugPrint("Upload error: $e");
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text("Do you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text(
              "Sure",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(String oldUsername) {
    TextEditingController nameController = TextEditingController(text: oldUsername);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Username"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "New Username",
            hintText: "Enter new name",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              String newUsername = nameController.text.trim();

              if (newUsername.isNotEmpty && newUsername != oldUsername) {
                try {
                  DocumentSnapshot oldDoc = await FirebaseFirestore.instance
                      .collection("collection_credential")
                      .doc(oldUsername)
                      .get();

                  if (oldDoc.exists) {
                    Map<String, dynamic> userData = oldDoc.data() as Map<String, dynamic>;

                    // Update username
                    userData["username"] = newUsername;

                    // Copy the whole document (including orders)
                    await FirebaseFirestore.instance.collection("collection_credential").doc(newUsername).set(userData);

                    // Delete old document
                    await FirebaseFirestore.instance.collection("collection_credential").doc(oldUsername).delete();

                    // Update SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("userId", newUsername);

                    if (!mounted) return;

                    // Restart MainPage with the new username
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainPage(userId: newUsername, password: userData["password"]),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  debugPrint("Error updating username: $e");
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Account"), backgroundColor: const Color(0xFF66B2C3), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("collection_credential").doc(widget.userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Profile updated. Please log out."));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String displayUsername = userData['username'] ?? "N/A";

          return Column(
            children: [
              // Profile Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(
                  color: Color(0xFF66B2C3),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,

                        backgroundImage: userData['photoUrl'] != null ? NetworkImage(userData['photoUrl']) : null,

                        child: userData['photoUrl'] == null
                            ? const Icon(Icons.person, size: 60, color: Color(0xFF66B2C3))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      displayUsername,
                      style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  children: [
                    _buildTile(
                      icon: Icons.edit,
                      title: "Edit Username",
                      onTap: () => _showEditNameDialog(displayUsername),
                    ),
                    _buildTile(
                      icon: Icons.history,
                      title: "Order History",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderHistoryPage(userId: widget.userId)),
                        );
                      },
                    ),
                    _buildTile(icon: Icons.logout, title: "Logout", iconColor: Colors.red, onTap: _showLogoutDialog),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF66B2C3),
  }) {
    return Card(
      elevation: 0.5,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
