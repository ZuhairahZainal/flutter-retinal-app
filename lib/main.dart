import 'package:flutter/material.dart';
import 'package:retinalapp/landing.dart';

void main() {
  runApp(MyRetinalApp());
}

class MyRetinalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retina Tracker',
      theme: ThemeData.light(),
      home: LandingScreen(),
    );
  }
}