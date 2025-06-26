
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:retinalapp/homepage.dart';
import 'package:retinalapp/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String username = '';
  String password = '';
  bool isLoading = false;
  String? errorMessage;
  final Color customBlue = Color(0xFF5A6E97);

  bool _logoVisible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _logoVisible = true;
      });
    });
  }

  Future<void> _loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        setState(() {
          errorMessage = 'Username not found.';
          isLoading = false;
        });
        return;
      }

      final email = query.docs.first['email'];
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? "Login failed.";
      });
    } catch (e) {
      setState(() {
        errorMessage = "Something went wrong.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF5),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 150, left: 50, right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            AnimatedOpacity(
              duration: Duration(milliseconds: 1000),
              opacity: _logoVisible ? 1.0 : 0.0,
              child: AnimatedScale(
                duration: Duration(milliseconds: 1000),
                scale: _logoVisible ? 1.0 : 0.7,
                curve: Curves.easeOutBack,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/logo.jpg',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => username = value.trim(),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please enter your username' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => password = value.trim(),
                    validator: (value) =>
                        value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 220,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _loginUser();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: customBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              color: customBlue,
                              fontWeight: FontWeight.bold,
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