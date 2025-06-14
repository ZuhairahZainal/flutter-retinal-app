import 'package:flutter/material.dart';

class UploadedScansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanned Image'),
      ),
      body: Center(
        child: Text(
          'This is the list of scanned retinal page',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}