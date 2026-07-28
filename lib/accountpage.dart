import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_app/main.dart';
import 'package:food_app/orderhistory.dart';

class AccountPage extends StatefulWidget {
  final String userId;
  const AccountPage({super.key, required this.userId});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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

                    userData['username'] = newUsername;

                    await FirebaseFirestore.instance.collection("collection_credential").doc(newUsername).set(userData);

                    await FirebaseFirestore.instance.collection("collection_credential").doc(oldUsername).delete();

                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("Username updated! Please login again.")));
                      _showLogoutDialog();
                    }
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
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 60, color: Color(0xFF66B2C3)),
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
