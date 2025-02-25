import 'package:flutter/material.dart';

class Profiles extends StatelessWidget {
  const Profiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/logo.png'), // Logo in AppBar
        ),
        title: const Text('Profile Home'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileOption(
              icon: Icons.edit,
              title: "Update Profile",
              onTap: () {
                // Navigate to update profile page
                print("Update Profile Clicked");
              },
            ),
            _buildProfileOption(
              icon: Icons.person,
              title: "Show Details",
              onTap: () {
                // Navigate to show details page
                print("Show Details Clicked");
              },
            ),
            _buildProfileOption(
              icon: Icons.logout,
              title: "Sign Out",
              onTap: () {
                // Handle sign-out logic
                print("Sign Out Clicked");
              },
            ),
            _buildProfileOption(
              icon: Icons.contact_mail,
              title: "Contact Us",
              onTap: () {
                // Navigate to contact page
                print("Contact Us Clicked");
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget for Long Container Button
  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}