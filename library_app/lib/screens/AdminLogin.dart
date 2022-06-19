import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/screens/AdminPage.dart';

class AdminLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<AdminLogin> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADMIN LOGIN'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Enter Username'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(hintText: 'Enter Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  login();
                });
              },
              child: Text('SignIn'))
        ]),
      ),
    );
  }

  Future<void> login() async {
    var response = await http.post(
        Uri.parse("https://sids438.pythonanywhere.com/login/"),
        body: ({
          'username': usernameController.text,
          'password': passwordController.text
        }));
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Invalid Credentials")));
    }
  }
}
