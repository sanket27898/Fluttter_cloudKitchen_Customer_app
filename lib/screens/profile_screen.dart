import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../screens/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Sign Out'),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
          },
        ),
      ),
    );
  }
}
