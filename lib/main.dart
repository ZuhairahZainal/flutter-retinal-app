import 'package:flutter/material.dart';
import 'package:retinalapp/landing.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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