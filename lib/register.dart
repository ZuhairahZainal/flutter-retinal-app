import 'package:flutter/material.dart';
import 'package:retinalapp/login.dart';
import 'package:retinalapp/register_credential.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String age = '';
  Map<String, bool> medicalConditions = {
    'Dementia': false,
    'Diabetes': false,
    'Other': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[700]),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Retinal Tracker',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Getting Started',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What\'s your name?',
                    style: TextStyle(
                      fontSize: 25, color: Colors.grey[800]
                    )
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'First name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),
                  Text('Health information',
                      style: TextStyle(
                        fontSize: 30, 
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      )
                  ),
                  SizedBox(height: 16),
                  Text('Existing Medical Conditions:',
                      style: TextStyle(
                        fontSize: 25, color: Colors.grey[800]
                      )
                  ),
                  SizedBox(height: 8),
                  Column(
                    children: medicalConditions.keys.map((condition) {
                      return CheckboxListTile(
                        title: Text(condition),
                        value: medicalConditions[condition],
                        onChanged: (bool? value) {
                          setState(() {
                            medicalConditions[condition] = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 24),
                  Text('How old are you?',
                      style: TextStyle(
                          fontSize: 25, color: Colors.grey[800]
                      )
                      ),
                  SizedBox(height: 8),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      age = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: 180,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterCredentialsPage(
                                  name: name,
                                  age: age,
                                  medicalConditions: medicalConditions,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => LoginPage()),
                        );
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[700],
                         
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}