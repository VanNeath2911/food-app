// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  bool isHidden = true;
  final Color primaryColor = const Color(0xFF66B2C3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Register",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
              ),
              const SizedBox(height: 30),
              _buildField("Username", Icons.person_outline, _user, false),
              const SizedBox(height: 15),
              _buildField("Password", Icons.lock_outline, _pass, true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    String username = _user.text.trim();
                    String password = _pass.text.trim();

                    if (username.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
                      return;
                    }

                    DocumentSnapshot user = await FirebaseFirestore.instance.collection("users").doc(username).get();

                    if (user.exists) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text("Username already exists")));
                      return;
                    }

                    await FirebaseFirestore.instance.collection("users").doc(username).set({
                      "username": username,
                      "password": password,
                      "created_at": FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Register Successful")));

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, TextEditingController ctrl, bool isPass) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? isHidden : false,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: primaryColor),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(isHidden ? Icons.visibility_off : Icons.visibility, size: 18),
                  onPressed: () => setState(() => isHidden = !isHidden),
                )
              : null,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
