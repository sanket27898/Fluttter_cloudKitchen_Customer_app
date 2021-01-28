import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/location_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _validPhoneNumber = false;
  var _phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
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
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
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
                      setState(() {
                        _validPhoneNumber = true;
                      });
                    } else {
                      setState(() {
                        _validPhoneNumber = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: AbsorbPointer(
                        absorbing: _validPhoneNumber ? false : true,
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              auth.loading = true;
                              auth.screen = 'MapScree';
                              auth.latitude = locationData.latitude;
                              auth.longitude = locationData.longitude;
                              auth.address =
                                  locationData.selectedAddress.addressLine;
                            });
                            String number = '+91${_phoneNumberController.text}';
                            print(number);
                            auth
                                .verifyPhone(
                              context: context,
                              number: number,
                            )
                                .then((value) {
                              _phoneNumberController.clear();

                              setState(() {
                                auth.loading = false;
                              });
                            });
                          },
                          color: _validPhoneNumber
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          child: auth.loading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  _validPhoneNumber
                                      ? 'CONTINUE'
                                      : 'ENTER PHONE NUMBER',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
