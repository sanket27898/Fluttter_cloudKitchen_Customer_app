import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/location_provider.dart';

import '../screens/map_screen.dart';
import '../screens/onboard_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String routeName = '/welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _validPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomsheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter myState) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: auth.error == 'Invalid OTP' ? true : false,
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              auth.error,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'LOGIN',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      'Enter your phone number to proceed',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixText: '+91',
                        labelText: '10 digit mobile number',
                      ),
                      controller: _phoneNumberController,
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onChanged: (value) {
                        if (value.length == 10) {
                          myState(() {
                            _validPhoneNumber = true;
                          });
                        } else {
                          myState(() {
                            _validPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _validPhoneNumber ? false : true,
                            child: FlatButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number =
                                    '+91${_phoneNumberController.text}';
                                print(number);
                                auth
                                    .verifyPhone(
                                  context: context,
                                  number: number,
                                )
                                    .then((value) {
                                  _phoneNumberController.clear();
                                });
                              },
                              color: _validPhoneNumber
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              child: auth.loading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      _validPhoneNumber
                                          ? 'CONTINUE'
                                          : 'ENTER PHONE NUMBER',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);
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
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: OnBoardScreen(),
              ),
              const Text(
                'Ready to order from your nearest shop?',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: locationData.loading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'SET DELIVERY LOCATION',
                        style: TextStyle(color: Colors.white),
                      ),
                onPressed: () async {
                  setState(() {
                    locationData.loading = true;
                  });
                  await locationData.getCurrentPosition();
                  if (locationData.permissionAllowed == true) {
                    Navigator.pushReplacementNamed(
                        context, MapScreen.routeName);
                    setState(() {
                      locationData.loading = false;
                    });
                  } else {
                    print('permission not allowed');
                    setState(() {
                      locationData.loading = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  setState(() {
                    auth.screen = 'Login';
                  });
                  showBottomsheet(context);
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Already a Customer ? ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
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
