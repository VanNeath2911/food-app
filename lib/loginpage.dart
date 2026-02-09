// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // ប្រាកដថាអ្នកមាន file នេះ
import 'main.dart';
import 'registerpage.dart';

void main() async {
  // ១. ចាំបាច់ត្រូវមាន ដើម្បីដំណើរការ Firebase មុនពេល App បើក
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF66B2C3)),
      // ២. កំណត់ឱ្យ LoginPage ជាទំព័រដំបូង
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
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  bool isPasswordHidden = true;
  bool isLoading = false;
  final Color primaryColor = const Color(0xFF66B2C3);

  Future<void> login() async {
    final user = controllerUsername.text.trim();
    final pass = controllerPassword.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("សូមបំពេញឱ្យគ្រប់ចន្លោះ")));
      return;
    }

    setState(() => isLoading = true);

    try {
      // ឆែក Username ក្នុង Firestore (Collection: collection_credential)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection("collection_credential").doc(user).get();

      if (userDoc.exists) {
        String dbPassword = userDoc.get('password');

        if (dbPassword == pass) {
          // ៣. បញ្ជូនទៅ MainPage ដោយប្រើ parameter ដើមរបស់អ្នក
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(userId: user, password: pass),
            ),
          );
        } else {
          _showError("លេខកូដសម្ងាត់មិនត្រឹមត្រូវ");
        }
      } else {
        _showError("រកមិនឃើញគណនីនេះទេ");
      }
    } catch (e) {
      _showError("មានបញ្ហា: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.restaurant_menu, size: 80, color: primaryColor),
              const SizedBox(height: 10),
              const Text("WELCOME", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              _buildField("Username", Icons.person, controllerUsername, false),
              const SizedBox(height: 15),
              _buildField("Password", Icons.lock, controllerPassword, true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : login,
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("LOGIN", style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
                child: Text("Register New Account", style: TextStyle(color: primaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, IconData icon, TextEditingController ctrl, bool isPass) {
    return TextField(
      controller: ctrl,
      obscureText: isPass ? isPasswordHidden : false,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon, color: primaryColor),
        suffixIcon: isPass
            ? IconButton(
                icon: Icon(isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => isPasswordHidden = !isPasswordHidden),
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
