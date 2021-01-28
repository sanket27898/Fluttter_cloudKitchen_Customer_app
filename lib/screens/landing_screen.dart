import 'package:flutter/material.dart';

import '../provider/location_provider.dart';
import '../screens/map_screen.dart';

class LandingScreen extends StatefulWidget {
  static const String routeName = '/landing_screen';
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not set',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please update your Delivery Location to find nearest store for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              width: 600,
              child: Image.asset(
                'images/city.png',
                fit: BoxFit.fill,
                color: Colors.black12,
              ),
            ),
            _loading
                ? CircularProgressIndicator()
                : FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });

                      await _locationProvider.getCurrentPosition();

                      if (_locationProvider.permissionAllowed == true) {
                        Navigator.pushReplacementNamed(
                            context, MapScreen.routeName);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.permissionAllowed == false) {
                            print('PerMission not allowed');
                            setState(() {
                              _loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please allow permission to find nearest stores for you'),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: Text(
                      'Set Your Location',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
