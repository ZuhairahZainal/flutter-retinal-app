import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:retinalapp/login.dart';
import 'package:retinalapp/register_credential.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String age = '';
  String otherCondition = '';
  Map<String, bool> medicalConditions = {
    'Dementia': false,
    'Diabetes': false,
    'Other': false,
  };

  final TextStyle headerStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final TextStyle labelStyle = TextStyle(fontSize: 25);
  final Color primaryTextColor = Colors.grey[800]!;
  final Color accentColor = Color(0xFF5A6E97); // updated color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 70, left: 20, right: 20),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/logo.jpg',
                height: 120,
              ),
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Getting Started', style: headerStyle.copyWith(color: primaryTextColor)),
                SizedBox(height: 25),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Enter your name", style: labelStyle.copyWith(color: primaryTextColor)),
                      SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'First name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor, width: 2),
                          ),
                        ),
                        onChanged: (value) => firstName = value,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your first name' : null,
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Last name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: accentColor, width: 2),
                          ),
                        ),
                        onChanged: (value) => lastName = value,
                        validator: (value) => value == null || value.isEmpty ? 'Please enter your last name' : null,
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Select your age', style: labelStyle.copyWith(color: primaryTextColor)),
                          InkWell(
                            onTap: () async {
                              int selectedAge = int.tryParse(age) ?? 18;
                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                      return AlertDialog(
                                        title: Text('Select Age'),
                                        content: SizedBox(
                                          width: 250,
                                          child: NumberPicker(
                                            minValue: 1,
                                            maxValue: 100,
                                            value: selectedAge,
                                            onChanged: (val) => setDialogState(() => selectedAge = val),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() => age = selectedAge.toString());
                                              Navigator.pop(context);
                                            },
                                            child: Text('Done'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: SizedBox(
                              width: 120,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey, width: 2),
                                ),
                                child: Text(
                                  age.isNotEmpty ? age : 'Select',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16, color: age.isNotEmpty ? Colors.black : Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text('Health information', style: headerStyle.copyWith(fontWeight: FontWeight.w500, color: primaryTextColor)),
                      SizedBox(height: 16),
                      Text('Existing Medical Conditions:', style: labelStyle.copyWith(color: primaryTextColor)),
                      SizedBox(height: 8),
                      Column(
                        children: medicalConditions.keys.map((condition) {
                          return Column(
                            children: [
                              CheckboxListTile(
                                title: Text(condition, style: TextStyle(color: primaryTextColor)),
                                value: medicalConditions[condition],
                                onChanged: (bool? value) => setState(() => medicalConditions[condition] = value ?? false),
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                              if (condition == 'Other' && medicalConditions['Other'] == true)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Please specify',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onChanged: (value) => otherCondition = value,
                                  ),
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: SizedBox(
                          width: 180,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (medicalConditions['Other'] == true && otherCondition.isNotEmpty) {
                                  medicalConditions[otherCondition] = true;
                                  medicalConditions.remove('Other');
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegisterCredentialsPage(
                                      name: '$firstName $lastName',
                                      age: age,
                                      medicalConditions: medicalConditions,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                            ),
                            child: Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
                          style: TextButton.styleFrom(
                            foregroundColor: accentColor,
                          ),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 18, color: primaryTextColor),
                              children: [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(text: 'Login', style: TextStyle(color: accentColor, fontWeight: FontWeight.bold)),
                              ],
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
          ],
        ),
      ),
    );
  }
}