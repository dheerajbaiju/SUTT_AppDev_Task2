import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:library_app/screens/AdminLogin.dart';
import 'package:library_app/screens/AdminPage.dart';
import 'package:library_app/screens/StudentPage.dart';
import 'package:library_app/screens/services/firebase_service.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('LIBRARY MANAGEMENT APP'),
          centerTitle: true,
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                    image: NetworkImage(
                        'https://www.kindpng.com/picc/m/382-3822504_clip-art-collection-free-book-transparent-animated-images.png')),
                SizedBox(
                  width: 80,
                  height: 80,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminLogin()),
                          );
                        },
                        child: Text('Admin Page')),
                    SizedBox(
                      width: 40,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await FirebaseService().signInWithGoogle();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentPage()),
                          );
                        },
                        child: Text('Google Sign-In'))
                  ],
                )
              ],
            )));
  }
}
