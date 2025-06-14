import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphDetailPage extends StatefulWidget {
  @override
  _GraphDetailPageState createState() => _GraphDetailPageState();
}

class _GraphDetailPageState extends State<GraphDetailPage> {
  String selectedRange = '3 months';

  final Map<String, List<FlSpot>> chartData = {
    '1 month': [FlSpot(0, 70), FlSpot(1, 68), FlSpot(2, 74), FlSpot(3, 73)],
    '3 months': [
      FlSpot(0, 60), FlSpot(1, 70), FlSpot(2, 64), FlSpot(3, 80),
      FlSpot(4, 70), FlSpot(5, 90), FlSpot(6, 60),
    ],
    '6 months': [
      FlSpot(0, 55), FlSpot(1, 63), FlSpot(2, 60),
      FlSpot(3, 66), FlSpot(4, 72), FlSpot(5, 75),
    ],
    '12 months': [
      FlSpot(0, 50), FlSpot(1, 55), FlSpot(2, 53), FlSpot(3, 60),
      FlSpot(4, 58), FlSpot(5, 63), FlSpot(6, 70), FlSpot(7, 72),
      FlSpot(8, 74), FlSpot(9, 71), FlSpot(10, 78), FlSpot(11, 80),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<String> ranges = ['1 month', '3 months', '6 months', '12 months'];

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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
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
                    'Eye Health Over Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: chartData[selectedRange]!,
                            isCurved: true,
                            color: Colors.white,
                            barWidth: 4,
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.white.withOpacity(0.25),
                            ),
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: ranges.map((range) {
                final isSelected = selectedRange == range;
                return GestureDetector(
                  onTap: () => setState(() => selectedRange = range),
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
                      range,
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
          ],
        ),
      ),
    );
  }
}