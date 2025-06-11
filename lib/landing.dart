import 'package:flutter/material.dart';
import 'package:retinalapp/register.dart';
import 'package:retinalapp/login.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                'retina',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              Text(
                'tracker',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'monitor your eye health',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey[600],
                ),
              ),
              Spacer(),

              // Main button → Login
              SizedBox(
                width: 220,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
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

              // Register link only
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text(
                  'Don\'t have an account? Register',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[700],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}