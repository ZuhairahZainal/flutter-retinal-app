import 'package:flutter/material.dart';

class RetinalConditionsPage extends StatelessWidget {
  final List<Map<String, dynamic>> conditions = [
    {
      'title': 'Age-Related Macular Degeneration (AMD)',
      'image': 'assets/amd.png',
      'symptoms': [
        'Fluid leakage or internal bleeding at the back of the eye',
        'Drusen (tiny yellow and white deposits)',
        'Pockets of fluid in the retina',
      ],
    },
    {
      'title': 'Diabetic Retinopathy',
      'image': 'assets/diabetic.png',
      'symptoms': [
        'Swelling of retinal veins',
        'Leakage of yellow fluids or blood from retinal vessels',
      ],
    },
    {
      'title': 'Glaucoma',
      'image': 'assets/glaucoma.png',
      'symptoms': [
        'Damage to the optic nerve from high eye pressure',
        'Thinning of the nerve fibre layer',
      ],
    },
    {
      'title': 'Hypertensive Retinopathy',
      'image': 'assets/hypertensive.png',
      'symptoms': [
        'Narrowing of arterioles and small blood vessels',
        'Cotton wool spots and microaneurysms',
        'Hard exudates and optic disc swelling (Papilledema)',
      ],
    },
    {
      'title': 'Ocular Melanoma',
      'image': 'assets/melanoma.png',
      'symptoms': [
        'Fluid accumulation',
        'Change in retina thickness',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        title: Text('Retinal Conditions'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Age-related diseases detectable through retinal imaging',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Retinal imaging is a non-invasive tool that helps detect various eye-related diseases. Below is an overview of common conditions and their visible symptoms.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            ...conditions.map((condition) => ConditionCard(condition: condition)).toList(),
          ],
        ),
      ),
    );
  }
}

class ConditionCard extends StatelessWidget {
  final Map<String, dynamic> condition;

  const ConditionCard({required this.condition});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 20),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                condition['image'],
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    condition['title'],
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  ...condition['symptoms'].map<Widget>((s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("• ", style: TextStyle(fontSize: 15)),
                            Expanded(
                              child: Text(
                                s,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}