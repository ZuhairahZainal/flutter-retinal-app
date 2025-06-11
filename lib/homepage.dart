import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Retinal Tracker',
          style: TextStyle(
            color: Colors.blue[700],
            fontWeight: FontWeight.bold,
            fontSize: 24, // larger
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.grey[700], size: 44), // larger icon
            onPressed: () {
              // Profile action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20), // more padding
        child: Column(
          children: [
            // Circular Progress
            Center(
              child: CircularPercentIndicator(
                radius: 140.0, // reduce slightly to fit well
                lineWidth: 25.0,
                percent: 0.40,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // <== important, prevents overflow
                  children: [
                    Text(
                      'Percent decline',
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                    Text(
                      '12%',
                      style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      'Eye Health',
                      style: TextStyle(color: Colors.grey[700], fontSize: 20),
                    ),
                  ],
                ),
                linearGradient: LinearGradient(
                  colors: [
                    Colors.blue[600]!,
                    Colors.blue[300]!,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                backgroundColor: Colors.grey[300]!,
              ),
            ),
                        SizedBox(height: 12),
            Text(
              'January 23, 2020 - April 22, 2025',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 20),

            // Metric Cards
            _buildMetricCard(
              title: 'Vessel Tortuosity',
              icon: Icons.show_chart,
              value: '1.3',
            ),
            SizedBox(height: 16),
            _buildMetricCard(
              title: 'Retinal Tissue Thickness',
              icon: Icons.view_list,
              value: '2.1',
            ),
            SizedBox(height: 20),

            // Average Eye Health Chart
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average eye health',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              FlSpot(0, 40),
                              FlSpot(1, 50),
                              FlSpot(2, 64),
                              FlSpot(3, 80),
                              FlSpot(4, 70),
                              FlSpot(5, 90),
                              FlSpot(6, 60),
                            ],
                            isCurved: true,
                            color: Colors.white,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.white.withOpacity(0.3),
                            ),
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
                      Text(
                        'PAST 7 MONTHS',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        '157',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 28),

            // Upload Photo Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Take or upload a photo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.arrow_forward, color: Colors.grey[700], size: 28),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(
                  icon: Icons.camera_alt,
                  onTap: () {
                    // Camera action
                  },
                ),
                _buildCircleButton(
                  icon: Icons.upload,
                  onTap: () {
                    // Upload action
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Bottom Link
            GestureDetector(
              onTap: () {
                // Learn more action
              },
              child: Text(
                'Learn about eye health',
                style: TextStyle(
                  color: Colors.grey[700],
                  decoration: TextDecoration.underline,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[700], size: 28),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100, // larger
        height: 100, // larger
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, size: 40, color: Colors.black), // larger icon
      ),
    );
  }
}