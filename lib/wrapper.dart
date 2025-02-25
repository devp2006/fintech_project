import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:npci/home.dart';
import 'package:npci/login.dart';



class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong.'));
        }
        if (snapshot.hasData) {
          return ChatScreen();
        } else {
          return Login();
        }
      },
    );
  }
}