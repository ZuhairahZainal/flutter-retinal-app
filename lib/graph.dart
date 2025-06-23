import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphDetailPage extends StatefulWidget {
  @override
  _GraphDetailPageState createState() => _GraphDetailPageState();
}

class _GraphDetailPageState extends State<GraphDetailPage> {
  String selectedMetric = 'Vessel Tortuosity';
  Map<String, List<FlSpot>> metricData = {
    'Vessel Tortuosity': [],
    'Max Tortuosity': [],
    'Retinopathy Score': [],
    'Risk of Macular Edema': [],
    'Number of Vessels': [],
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGraphData();
  }

  double get minY {
    switch (selectedMetric) {
      case 'Retinopathy Score':
        return 0;
      case 'Risk of Macular Edema':
        return 0;
      case 'Number of Vessels':
        return 0;
      case 'Vessel Tortuosity':
      case 'Max Tortuosity':
        return 0;
      default:
        return 0;
    }
  }

  double get maxY {
    switch (selectedMetric) {
      case 'Retinopathy Score':
        return 5;
      case 'Risk of Macular Edema':
        return 1;
      case 'Number of Vessels':
        return 180;
      case 'Vessel Tortuosity':
        return 100;
      case 'Max Tortuosity':
        return 600;
      default:
        return 100;
    }
  }

  double get interval {
    switch (selectedMetric) {
      case 'Retinopathy Score':
        return 1;
      case 'Risk of Macular Edema':
        return 1;
      case 'Number of Vessels':
        return 20;
      case 'Vessel Tortuosity':
        return 20;
      case 'Max Tortuosity':
        return 100;
      default:
        return 10;
    }
  }

  Future<void> _loadGraphData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('retinal_scans')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp')
        .get();

    int index = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      metricData['Vessel Tortuosity']!
          .add(FlSpot(index.toDouble(), (data['average_tortuosity'] ?? 0).toDouble()));
      metricData['Max Tortuosity']!
          .add(FlSpot(index.toDouble(), (data['max_tortuosity'] ?? 0).toDouble()));
      metricData['Retinopathy Score']!
          .add(FlSpot(index.toDouble(), (data['retinopathy_grade'] ?? 0).toDouble()));
      metricData['Risk of Macular Edema']!
          .add(FlSpot(index.toDouble(), (data['edema_risk'] ?? 0).toDouble()));
      metricData['Number of Vessels']!
          .add(FlSpot(index.toDouble(), (data['num_vessels'] ?? 0).toDouble()));
      index++;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final metrics = metricData.keys.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            iconSize: 30,
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              'Retinal Tracker',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: metrics.map((metric) {
                      final isSelected = selectedMetric == metric;
                      return GestureDetector(
                        onTap: () => setState(() => selectedMetric = metric),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[700] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    )
                                  ]
                                : [],
                          ),
                          child: Text(
                            metric,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.grey[800],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedMetric,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 500,
                          child: LineChart(
                            LineChartData(
                              minY: minY,
                              maxY: maxY,
                              lineTouchData: LineTouchData(
                                enabled: true,
                                touchTooltipData: LineTouchTooltipData(
                                  tooltipBgColor: Colors.black87,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      return LineTooltipItem(
                                        '${spot.y.toStringAsFixed(1)}',
                                        TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              gridData: FlGridData(show: true, drawVerticalLine: true),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: interval,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toStringAsFixed(0),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: metricData[selectedMetric]!,
                                  isCurved: true,
                                  color: Colors.white,
                                  barWidth: 4,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        strokeColor: Colors.blue[800]!,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}