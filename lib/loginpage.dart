// ignore_for_file: deprecated_member_use, use_build_context_synchronously, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/firebase_options.dart';
import 'package:food_app/main.dart';
import 'package:food_app/registerpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Added for Firebase safety
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((_) {
    print("Firebase connected.");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();

  bool is_password_visible = true;

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  Widget build(BuildContext context) {
    // Determine card width to prevent it from being "too big"
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth > 600 ? 400 : screenWidth * 0.85;

    return Scaffold(
      // FEATURE: Using your signature Teal background
      backgroundColor: const Color(0xFF66B2C3),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo and Header
              const Icon(Icons.fastfood, size: 80, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),

              // THE CARD CONTAINER (Matches your Radius 28 style)
              Container(
                width: cardWidth,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username Field
                    TextField(
                      controller: controller_username,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextField(
                      controller: controller_password,
                      obscureText: is_password_visible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: const UnderlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              is_password_visible = !is_password_visible;
                            });
                          },
                          icon: Icon(is_password_visible ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    // Login Button (Using your Deep Purple design)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          String username = controller_username.text;
                          String password = controller_password.text;

                          await db
                              .collection("collection_user")
                              .where("username", isEqualTo: username)
                              .where("password", isEqualTo: password)
                              .get()
                              .then((q) {
                                if (q.docs.isEmpty) {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).showSnackBar(const SnackBar(content: Text("Login failed. Wrong credentials.")));
                                } else {
                                  Navigator.of(
                                    context,
                                  ).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
                                }
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        child: const Text("Login", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Register Link
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterPage(title: "")));
                },
                child: const Text(
                  "Don't have an account? Register here",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
