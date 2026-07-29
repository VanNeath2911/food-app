// ignore_for_file: use_build_context_synchronously, duplicate_import, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service/firebase_options.dart';
import 'widget/navigationbar.dart';
import 'auth/registerpage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();

  bool isLogin = prefs.getBool("isLogin") ?? false;
  String? userId = prefs.getString("userId");
  String? password = prefs.getString("password");

  runApp(MyApp(isLogin: isLogin, userId: userId, password: password));
}

class MyApp extends StatelessWidget {
  final bool isLogin;
  final String? userId;
  final String? password;

  const MyApp({super.key, required this.isLogin, this.userId, this.password});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF66B2C3)),
      home: isLogin ? MainPage(userId: userId!, password: password!) : const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;
  final Color primaryColor = const Color(0xFF66B2C3);

  Future<void> login() async {
    final user = controllerUsername.text.trim();
    final pass = controllerPassword.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    setState(() => isLoading = true);

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("users").doc(user).get();

      if (userDoc.exists) {
        String dbPassword = userDoc.get('password');

        if (dbPassword == pass) {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setBool("isLogin", true);
          await prefs.setString("userId", user);
          await prefs.setString("password", pass);

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(userId: user, password: pass),
            ),
          );
        } else {
          _showError("Incorrect password. Please try again!");
        }
      } else {
        _showError("User not found.");
      }
    } catch (e) {
      _showError("An error occurred. Please check your internet.");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(Icons.restaurant_menu, size: 80, color: primaryColor),
              const SizedBox(height: 20),
              const Text(
                "LOGIN",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66B2C3),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 40),

              // Username Field (Fixed Style)
              _buildField("Username", Icons.person, controllerUsername, false),

              const SizedBox(height: 15),

              // Password Field (Fixed Style)
              _buildField("Password", Icons.lock, controllerPassword, true),

              const SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "LOGIN",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              // Register Link
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: Text("Register New Account", style: TextStyle(color: primaryColor.withOpacity(0.8))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, TextEditingController ctrl, bool isPass) {
    return Container(
      width: 300,
      decoration: BoxDecoration(color: const Color(0xFFF1F1F1), borderRadius: BorderRadius.circular(12)),
      child: TextField(
        controller: ctrl,
        obscureText: isPass ? isPasswordHidden : false,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          prefixIcon: Icon(icon, color: primaryColor.withOpacity(0.6), size: 20),
          suffixIcon: isPass
              ? IconButton(
                  icon: Icon(
                    isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[400],
                    size: 18,
                  ),
                  onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
                )
              : null,
          border: InputBorder.none, // លុបបន្ទាត់ស៊ុមចេញ
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        ),
      ),
    );
  }
}
