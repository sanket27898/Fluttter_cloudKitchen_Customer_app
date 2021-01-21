import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

import '../screens/welcome_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RaisedButton(
              onPressed: () {
                auth.error = '';
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
                    ),
                  );
                });
              },
              child: Text('Sign out'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, WelcomeScreen.routeName);
              },
              child: Text('home screen'),
            ),
          ],
        ),
      ),
    );
  }
}
