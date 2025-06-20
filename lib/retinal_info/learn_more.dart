import 'package:flutter/material.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn More'),
      ),
      body: Center(
        child: Text(
          'This is learn more page',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}