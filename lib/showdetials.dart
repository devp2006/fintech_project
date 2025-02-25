import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text("Profile Details"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(user?.displayName ?? "Not set", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text("Email:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(user?.email ?? "Not set", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
