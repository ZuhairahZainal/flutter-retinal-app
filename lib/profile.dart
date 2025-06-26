import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retinalapp/landing.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? age;
  List<String> medicalConditions = [];
  List<String> customConditions = [];
  bool isLoading = true;

  final List<String> allConditions = ['Dementia', 'Diabetes', 'Other'];
  final TextEditingController _otherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          username = data['username'];
          firstName = data['firstName'];
          lastName = data['lastName'];
          email = data['email'];
          age = data['age'];
          medicalConditions = List<String>.from(data['medicalConditions'] ?? []);
          customConditions = List<String>.from(data['customConditions'] ?? []);
          isLoading = false;
        });
      }
    }
  }

  Future<void> _saveConditions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'medicalConditions': medicalConditions,
        'customConditions': customConditions,
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LandingScreen()),
      (route) => false,
    );
  }

  void _showOtherDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Other Condition"),
        content: TextField(
          controller: _otherController,
          decoration: InputDecoration(hintText: 'Enter condition'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String input = _otherController.text.trim();
              if (input.isNotEmpty && !customConditions.contains(input)) {
                setState(() {
                  customConditions.add(input);
                });
                _saveConditions();
              }
              _otherController.clear();
              Navigator.pop(context);
            },
            child: Text("Save", style: TextStyle(color: Color(0xFF5A6E97))),
          )
        ],
      ),
    );
  }

  void _removeCustomCondition(String condition) {
    setState(() {
      customConditions.remove(condition);
      if (customConditions.isEmpty && medicalConditions.contains('Other')) {
        medicalConditions.remove('Other');
      }
    });
    _saveConditions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF5A6E97)),
        title: Text(
          'Profile',
          style: TextStyle(color: Color(0xFF5A6E97), fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.red[400]),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue[100],
                      child: Icon(Icons.person, size: 60, color: Color(0xFF5A6E97)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      username ?? 'No username',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildProfileItem(Icons.person, 'First Name', firstName ?? ''),
                  SizedBox(height: 16),
                  _buildProfileItem(Icons.person_outline, 'Last Name', lastName ?? ''),
                  SizedBox(height: 16),
                  _buildProfileItem(Icons.email, 'Email', email ?? ''),
                  SizedBox(height: 16),
                  _buildProfileItem(Icons.cake, 'Age', age ?? ''),
                  SizedBox(height: 24),
                  Text('Medical Conditions:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Column(
                    children: allConditions.map((condition) {
                      return CheckboxListTile(
                        title: Text(condition),
                        value: medicalConditions.contains(condition),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              medicalConditions.add(condition);
                              if (condition == 'Other') {
                                _showOtherDialog();
                              }
                            } else {
                              medicalConditions.remove(condition);
                            }
                            _saveConditions();
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (customConditions.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text('Other Conditions:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    SizedBox(height: 8),
                    Column(
                      children: customConditions.map((cond) {
                        return ListTile(
                          title: Text(cond),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[300]),
                            onPressed: () => _removeCustomCondition(cond),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildProfileItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF5A6E97)),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[700])),
              SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            ],
          ),
        )
      ],
    );
  }
}