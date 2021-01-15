import 'package:flutter/material.dart';

import '../screens/onboard_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(children: [
          Positioned(
            top: 20,
            right: 30,
            child: InkWell(
              onTap: () {},
              child: Text(
                'SKIP',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: OnBoardScreen(),
              ),
              Text(
                'Ready to order from your nearest shop?',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              FlatButton(
                color: Colors.orange,
                child: Text(
                  'Set Delivery Location',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: RichText(
                  text: TextSpan(
                    text: 'Already a Customer ? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
