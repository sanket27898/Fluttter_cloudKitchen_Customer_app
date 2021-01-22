import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

import '../screens/welcome_screen.dart';
import '../widgets/image_slider.dart';
import '../widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: Column(
        children: [
          ImageSlider(),
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
    );
  }
}
