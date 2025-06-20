import 'package:flutter/material.dart';

class VesselCurvatureInfoPage extends StatelessWidget {
  final List<Map<String, dynamic>> conditions = [
    {
      'title': 'Cardiovascular Disease',
      'desc':
          'Retinal arteries become more twisted with high blood pressure, aging, or high body weight. Vein curves can reflect cholesterol issues.'
    },
    {
      'title': 'Diabetic Retinopathy',
      'desc':
          'Eye vessel curves increase in early diabetes, helping detect the condition early.'
    },
    {
      'title': 'Retinal Vein Occlusion (RVO)',
      'desc':
          'Veins get swollen and twisted, which can lead to vision loss and swelling in the eye.'
    },
    {
      'title': 'Blood Disorders & Low Oxygen (e.g., Sickle Cell Disease)',
      'desc':
          'Twisted vessels are more common in people with sickle cell or anemia and may show how serious the disease is.'
    },
    {
      'title': 'Inherited Eye Conditions',
      'desc':
          'Some people are born with extremely twisted vessels. It can cause bleeding but may not affect vision much.'
    },
    {
      'title': 'Other Eye Diseases (e.g., Coats’ Disease)',
      'desc':
          'In early stages, vessels become dilated and twisted, possibly leading to serious eye problems if untreated.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Curved Vessels & Health"),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'What Curved Eye Vessels Tell Us About Health',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/vessel_normal.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/vessel_twisted.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: Colors.black, width: 3),
              ),
            ),
            child: Text(
              'As we age, our eyes can show signs of what’s happening inside our bodies.\n\nOne of these signs is vessel tortuosity or how twisted or curved the tiny blood vessels in our eyes become.\n\nThese changes can help doctors detect or monitor various health conditions, even before symptoms appear.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
          SizedBox(height: 24),
          ...conditions.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${entry.key + 1}. ${entry.value['title']}\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        TextSpan(text: entry.value['desc']),
                      ],
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}