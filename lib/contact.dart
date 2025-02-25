import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Us"), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 100, color: Colors.blue),
            SizedBox(height: 10),
            Text("Support: 9372659160", style: TextStyle(fontSize: 18)),
            SizedBox(height: 5),
            Text("Email: surasaumya17@gmail.com", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
