import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/screens/AdminPage.dart';

class AdminLogin extends StatelessWidget {
  final emailController = TextEditingController();
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
            controller: emailController,
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
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                } catch (e) {
                  var alertDialog = AlertDialog(
                    title: Text("Alert"),
                    content: Text('Incorrect email or password'),
                  );

                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alertDialog;
                      });
                }
              },
              child: Text('SignIn'))
        ]),
      ),
    );
  }
}

class AuthenticationService {}
