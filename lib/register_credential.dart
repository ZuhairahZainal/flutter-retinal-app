import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:retinalapp/homepage.dart';
import 'package:retinalapp/login.dart';

class RegisterCredentialsPage extends StatefulWidget {
  final String name;
  final String age;
  final Map<String, bool> medicalConditions;

  RegisterCredentialsPage({
    required this.name,
    required this.age,
    required this.medicalConditions,
  });

  @override
  _RegisterCredentialsPageState createState() => _RegisterCredentialsPageState();
}

class _RegisterCredentialsPageState extends State<RegisterCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String username = '';
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final nameParts = widget.name.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
        'age': widget.age,
        'email': email,
        'medicalConditions': widget.medicalConditions.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Registration Successful'),
          content: Text('Your profile has been saved.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => HomePage()),
                );
              },
              child: Text('OK', style: TextStyle(color: Color(0xFF5A6E97))),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF5A6E97)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/logo.jpg',
                height: 150,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32),
                Text(
                  'Register an Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  )
                ),
                SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (val) => username = val,
                        validator: (val) => val != null && val.length >= 3 ? null : "Enter a valid username",
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (val) => email = val,
                        validator: (val) => val != null && val.contains('@') ? null : "Enter a valid email",
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(fontWeight: FontWeight.w600),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        obscureText: true,
                        onChanged: (val) => password = val,
                        validator: (val) => val != null && val.length >= 6 ? null : "Minimum 6 characters",
                      ),
                      SizedBox(height: 36),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5A6E97),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
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
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                              children: [
                                TextSpan(text: 'Already have an account? '),
                                TextSpan(text: 'Login', style: TextStyle(color: Color(0xFF5A6E97), fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
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