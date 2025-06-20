import 'package:flutter/material.dart';

class RetinopathyGradesPage extends StatelessWidget {
  final List<Map<String, dynamic>> grades = [
    {
      'grade': '0',
      'description': 'No damage visible',
      'risk': 'No risk',
      'level': 'none',
    },
    {
      'grade': '1',
      'description':
          'Mild damage:\nSmall balloon-like bulges (microaneurysms)',
      'risk': 'Low risk',
      'level': 'low',
    },
    {
      'grade': '2',
      'description':
          'Moderate damage:\nMore bulges, bleeding spots, mild vein changes',
      'risk': 'Medium risk',
      'level': 'medium',
    },
    {
      'grade': '3',
      'description':
          'Severe damage:\nMany bleeding spots, twisted veins,\nabnormal new vessels (IRMA)',
      'risk': 'High risk of swelling and vision loss',
      'level': 'high',
    },
  ];

  Color getRiskColor(String level) {
    switch (level) {
      case 'low':
        return Colors.green.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'high':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: const Text("Retinopathy Grades"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Understanding Diabetic Retinopathy Grades and Vision Risk",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(left: BorderSide(color: Colors.black, width: 2)),
              ),
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 20, height: 1.4, color: Colors.black),
                  children: [
                    TextSpan(
                      text:
                          "If you have diabetes, your doctor may mention something called Diabetic Retinopathy (DR). It means that the small blood vessels in your eyes are being affected by high blood sugar. DR is graded from 0 to 3, and knowing your grade can help prevent vision problems like ",
                    ),
                    TextSpan(
                      text: "Macular Edema",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    TextSpan(
                      text:
                          " (swelling in the center of the eye).\n\nHere’s what each grade means:",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 48,
                  dataRowMinHeight: 80,
                  dataRowMaxHeight: 160,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Grade',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Risk of Macular Edema',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ],
                  rows: grades.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['grade'], style: const TextStyle(fontSize: 17))),
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 80, maxWidth: 200),
                            child: Text(
                              item['description'],
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 17,
                                fontStyle: item['grade'] != '0' ? FontStyle.italic : null,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 200,
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: getRiskColor(item['level']),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item['risk'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}