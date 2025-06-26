import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UploadedScansPage extends StatelessWidget {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Scanned Images')),
        body: Center(child: Text('User not logged in.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: Text('Retinal Scan', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF5A6E97),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('retinal_scans')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final scans = snapshot.data!.docs;

          if (scans.isEmpty) {
            return Center(child: Text('No scans uploaded yet.'));
          }

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, index) {
              final scan = scans[index].data() as Map<String, dynamic>;
              final date = DateTime.parse(scan['date']);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye_outlined, color: Colors.grey[700]),
                          SizedBox(width: 8),
                          Text(
                            '${scan['eyeSide']} Eye - ${DateFormat.yMMMd().format(date)}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.timeline, size: 17, color: Color(0xFF5A6E97)),
                          SizedBox(width: 6),
                          Text('Avg Tortuosity: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                          Text('${scan['average_tortuosity']?.toStringAsFixed(2)}', style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.trending_up, size: 17, color: Colors.redAccent),
                          SizedBox(width: 6),
                          Text('Max Tortuosity: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                          Text('${scan['max_tortuosity']?.toStringAsFixed(2)}', style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.bubble_chart, size: 17, color: Colors.teal),
                          SizedBox(width: 6),
                          Text('Vessels: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                          Text('${scan['num_vessels']}', style: TextStyle(fontSize: 17)),
                        ],
                      ),
                      if (scan['retinopathy_grade'] != null) ...[
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.stacked_line_chart, size: 17, color: Colors.orange),
                            SizedBox(width: 6),
                            Text('Grade: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                            Text('${scan['retinopathy_grade']}', style: TextStyle(fontSize: 17)),
                          ],
                        ),
                      ],
                      if (scan['edema_risk'] != null) ...[
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.warning_amber, size: 17, color: Colors.pinkAccent),
                            SizedBox(width: 6),
                            Text('Edema Risk: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
                            Text('${scan['edema_risk']}', style: TextStyle(fontSize: 17)),
                          ],
                        ),
                      ],
                      if (scan['notes'] != null && scan['notes'].toString().trim().isNotEmpty) ...[
                        SizedBox(height: 10),
                        Text(
                          'Notes: ${scan['notes']}',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[700]),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}