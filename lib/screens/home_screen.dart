import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/auth_provider.dart';
import '../provider/location_provider.dart';

import '../screens/welcome_screen.dart';
import '../screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _location = '';
  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    setState(() {
      _location = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        title: FlatButton(
          onPressed: () {
            locationData.getCurrentPosition();
            if (locationData.permissionAllowed == true) {
              Navigator.pushNamed(context, MapScreen.routeName);
            } else {
              print('Permission not allowed');
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _location == null ? 'Address not set' : _location,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.edit_outlined,
                color: Colors.white,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
            ),
          )
        ],
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
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
