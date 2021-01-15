import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'logo',
            child: Image.asset('images/logo.png'),
          ),
          TextField(),
          TextField(),
          TextField(),
          TextField(),
        ],
      ),
    );
  }
}
