
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:npci/home.dart';
import 'package:npci/login.dart';
import 'package:npci/signup.dart';
import 'package:npci/wrapper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        themeMode: ThemeMode.dark,
        routes: {
          '/': (context) =>  Wrapper(),
          '/chat': (context) =>  ChatScreen(),

            '/login': (context) =>  Login(),
            '/signup': (context) =>  SignUp(),
        },
    );
  }
}