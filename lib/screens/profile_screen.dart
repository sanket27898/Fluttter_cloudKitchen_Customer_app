import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../screens/welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: const Text('Sign Out'),
          onPressed: () {
            FirebaseAuth.instance.signOut();

            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: WelcomeScreen.routeName),
              screen: WelcomeScreen(),
              withNavBar:
                  false, //make this false if your are navigating to outside
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        ),
      ),
    );
  }
}
