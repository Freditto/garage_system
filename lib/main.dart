import 'package:flutter/material.dart';
import 'package:garage_app/driver/auth.dart';
import 'package:garage_app/driver/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      
      home: LoginScreen(),
    );
  }
}

