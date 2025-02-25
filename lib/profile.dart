import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(padding: EdgeInsets.all(9.0),

            child:  CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/image.png'),
            )  
          ),
      ),

    );
  }
}