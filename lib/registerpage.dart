// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_app/firebase_options.dart';

void main() async {
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
      title: 'SignUp Page',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const RegisterPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // create controller for textfields
  TextEditingController controller_username = TextEditingController();
  TextEditingController controller_password = TextEditingController();
  TextEditingController controller_confirm_password = TextEditingController();

  bool is_password_visible = true;
  bool is_confirm_password_visible = true;

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Spacer(),
                Container(alignment: Alignment.centerRight, width: 130, child: Text("Username: ")),
                SizedBox(width: 250, child: TextField(controller: controller_username)),
                SizedBox(width: 46),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Container(alignment: Alignment.centerRight, width: 170, child: Text("Password: ")),
                SizedBox(
                  width: 250,
                  child: TextField(obscureText: is_password_visible, controller: controller_password),
                ),
                IconButton(
                  onPressed: () {
                    is_password_visible = !is_password_visible;
                    setState(() {});
                  },
                  icon: !is_password_visible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                SizedBox(width: 46),
                Spacer(),
              ],
            ),
            Row(
              children: [
                Spacer(),
                Container(alignment: Alignment.centerRight, width: 130, child: Text("Confirm Password: ")),
                SizedBox(
                  width: 250,
                  child: TextField(obscureText: is_confirm_password_visible, controller: controller_confirm_password),
                ),
                IconButton(
                  onPressed: () {
                    is_confirm_password_visible = !is_confirm_password_visible;
                    setState(() {});
                  },
                  icon: !is_confirm_password_visible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                SizedBox(width: 5),
                Spacer(),
              ],
            ),
            SizedBox(height: 20, width: 10),
            OutlinedButton(
              onPressed: () async {
                String username = controller_username.text;
                // print("Username: $username");
                String password = controller_password.text;
                // print("Password: $password");
                String confirm_password = controller_confirm_password.text;
                // print("Confirm Password: $confirm_password");

                if (password != confirm_password) {
                  print("Password and Confirm Password do not match.");
                  return;
                }

                if (username.length < 5) {
                  print("Username must be at least 5 characters long.");
                  return;
                }
                if (password.length < 5) {
                  print("Password must be at least 5 characters long.");
                  return;
                }

                await db
                    .collection("collection_credential")
                    .add({
                      "username": username,
                      "password": password,
                      "created_at": DateTime.now(),
                      "updated_at": DateTime.now(),
                    })
                    .then((q) {
                      print("User registered successfully.");
                    })
                    .catchError((e) {
                      print("Error registering.");
                    });
              },
              child: Text("Sign Up"),
            ),
          ], //
        ),
      ),
    );
  }
}
