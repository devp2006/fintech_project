import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileHome extends StatelessWidget {
  const ProfileHome({super.key});

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signed out successfully")),
      );
      Navigator.pushReplacementNamed(context, '/login'); // Redirect to login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // Logo in app bar
        ),
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile.jpg'), // Profile Image
            ),
            SizedBox(height: 20),

            // Update Profile Container
            _buildContainer(
              context,
              title: "Update Profile",
              icon: Icons.edit,
              onTap: () {
                Navigator.pushNamed(context, '/updateProfile');
              },
            ),

            // Show Details Container
            _buildContainer(
              context,
              title: "Show Details",
              icon: Icons.info,
              onTap: () {
                Navigator.pushNamed(context, '/profileDetails');
              },
            ),

            // Contact Us Container
            _buildContainer(
              context,
              title: "Contact Us",
              icon: Icons.phone,
              onTap: () {
                Navigator.pushNamed(context, '/contactUs');
              },
            ),

            // Sign Out Container
            _buildContainer(
              context,
              title: "Sign Out",
              icon: Icons.logout,
              onTap: () {
                _signOut(context);
              },
              color: Colors.redAccent, // Different color for sign-out
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap, Color color = Colors.blueAccent}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: Colors.white),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
