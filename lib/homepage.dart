import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:retinalapp/graph.dart';
import 'package:retinalapp/img_list.dart';
import 'package:retinalapp/retinal_info/RetinopathyGradesPage.dart';
import 'package:retinalapp/retinal_info/VesselCurvatureInfoPage.dart';
import 'package:retinalapp/retinal_info/learn_more.dart';
import 'package:retinalapp/profile.dart';
import 'package:retinalapp/retinal_info/retinal_conditions_page.dart';
import 'package:retinalapp/upload.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double avgTortuosity = 0.0;
  double avgRetinopathy = 0.0;
  double avgEdemaRisk = 0.0;
  bool hasGlaucoma = false;
  List<String> glaucomaCharacteristics = [];
  List<FlSpot> _tortuositySpots = [];

  @override
  void initState() {
    super.initState();
    _calculateAverages();
    _loadTortuosityGraphData();
  }

  Future<void> _calculateAverages() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('retinal_scans')
        .where('userId', isEqualTo: userId)
        .get();

    double totalTortuosity = 0.0;
    double totalRetino = 0.0;
    double totalEdema = 0.0;
    int count = 0;
    int suspectedGlaucoma = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      totalTortuosity += (data['average_tortuosity'] ?? 0.0);
      totalRetino += (data['retinopathy_grade'] ?? 0.0); 
      totalEdema += (data['edema_risk'] ?? 0.0);
      count++;

      if ((data['retinopathy_grade'] ?? 0.0) >= 2.5) { 
        suspectedGlaucoma++;
      }
    }

    if (count > 0) {
      setState(() {
        avgTortuosity = totalTortuosity / count;
        avgRetinopathy = totalRetino / count;
        avgEdemaRisk = totalEdema / count;
        hasGlaucoma = suspectedGlaucoma >= (count / 2);
        glaucomaCharacteristics = hasGlaucoma
            ? ["Optic nerve cupping", "Increased IOP", "Visual field loss"]
            : [];
      });
    }
  }

  Future<void> _loadTortuosityGraphData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('retinal_scans')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp')
        .get();

    final List<FlSpot> spots = [];
    int index = 0;

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final tort = data['average_tortuosity'];
      if (tort != null) {
        spots.add(FlSpot(index.toDouble(), (tort as num).toDouble()));
        index++;
      }
    }

    setState(() {
      _tortuositySpots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Retinal Tracker',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.grey[700], size: 45),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please log in first.')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricCard(title: 'Vessel Tortuosity', icon: Icons.show_chart, value: avgTortuosity.toStringAsFixed(2)),
            SizedBox(height: 16),
            _buildMetricCard(title: 'Retinopathy Score', icon: Icons.view_list, value: avgRetinopathy.toStringAsFixed(2)),
            SizedBox(height: 16),
            _buildMetricCard(title: 'Risk of Macular Edema', icon: Icons.opacity, value: avgEdemaRisk.toStringAsFixed(2)),
            SizedBox(height: 16),
            _buildGlaucomaCard(hasGlaucoma: hasGlaucoma, characteristics: glaucomaCharacteristics),
            SizedBox(height: 20),
            _buildGraphCard(),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('View Retina Scans', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UploadedScansPage())),
                  child: Icon(Icons.arrow_forward, color: Colors.grey[700], size: 28),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildUploadButton(),
            SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildLearningCard(imagePath: 'assets/amd.png', title: 'Age-related diseases detectable through retinal imaging', subtitle: '3 min', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RetinalConditionsPage()))),
                  SizedBox(width: 16),
                  _buildLearningCard(imagePath: 'assets/vessel_normal.png', title: 'What Curved Eye Vessels Tell Us About Health', subtitle: '3 min', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VesselCurvatureInfoPage()))),
                  SizedBox(width: 16),
                  _buildLearningCard(imagePath: 'assets/retina_photo.png', title: 'Understanding Diabetic Retinopathy Grades and Vision Risk', subtitle: '3 min', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RetinopathyGradesPage()))),
                  SizedBox(width: 16),
                  _buildLearningCard(imagePath: 'assets/eyes.png', title: 'How to take and upload a retinal photo', subtitle: '5 min', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LearnMorePage()))),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({required String title, required IconData icon, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [Icon(icon, color: Colors.grey[700], size: 28), SizedBox(width: 12), Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600))]),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.red[300], borderRadius: BorderRadius.circular(12)),
            child: Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ],
      ),
    );
  }

  Widget _buildGlaucomaCard({required bool hasGlaucoma, required List<String> characteristics}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.remove_red_eye, color: Colors.blue[700]),
              SizedBox(width: 12),
              Text('Glaucoma', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800])),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                decoration: BoxDecoration(
                  color: hasGlaucoma ? Colors.red[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(hasGlaucoma ? 'Yes' : 'No', style: TextStyle(color: hasGlaucoma ? Colors.red[800] : Colors.green[800], fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          if (hasGlaucoma && characteristics.isNotEmpty) ...[
            SizedBox(height: 12),
            Text('Characteristics:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: characteristics.map((c) => Chip(label: Text(c), backgroundColor: Colors.grey[200])).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGraphCard() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GraphDetailPage())),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.blue[600], borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average eye health', style: TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: _tortuositySpots.isEmpty
                  ? Center(child: CircularProgressIndicator(color: Colors.white))
                  : LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: _tortuositySpots,
                            isCurved: true,
                            color: Colors.white,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(show: true, color: Colors.white.withOpacity(0.3)),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('PAST ENTRIES', style: TextStyle(color: Colors.white70, fontSize: 16)),
                Text(
                  _tortuositySpots.isEmpty
                      ? '0.0'
                      : _tortuositySpots.map((e) => e.y).reduce((a, b) => a + b).toStringAsFixed(1),
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UploadRetinalScanPage())),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(color: Color(0xFF2196F3), borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add_a_photo, color: Colors.white), SizedBox(width: 10), Text('Upload Retinal Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))],
        ),
      ),
    );
  }

  Widget _buildLearningCard({required String imagePath, required String title, required String subtitle, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover)),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
          ],
        ),
      ),
    );
  }
}