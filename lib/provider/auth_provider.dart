import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/user_services.dart';
import '../screens/home_screen.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOtp;
  String verificationId;
  String error = '';
  UserServices _userServices = UserServices();

  Future<void> verifyPhone(BuildContext context, String number) async {
    print("saket$number");
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      // ANDROID ONLY!
      print("varifiction Completed sanket");
      print("varifiction Completed sanket$credential");

      // Sign the user in (or link) with the auto-generated credential
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print("varifiction fail sanket");
      print(e);
      // Handle other errors
    };

    final PhoneCodeSent smsOtpSend = (String verId, int resendToken) async {
      print(" smsOtpSend sanket");

      this.verificationId = verId;

      // open dialog to enter received OTP SMS
      smsOtpDialog(context, number);
    };
    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: smsOtpSend,
        codeAutoRetrievalTimeout: (String verId) {
          print(" codeAutoRetrievalTimeout sanket");

          this.verificationId = verId;
        },
      );
    } catch (e) {
      print("sanket $e");
      print(e);
    }
  }

  Future<bool> smsOtpDialog(BuildContext context, String number) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                Text('Verification code'),
                SizedBox(
                  height: 6,
                ),
                Text(
                  'Enter 6 digit OTP receive as SMS',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            content: Container(
              height: 85,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 6,
                onChanged: (value) {
                  this.smsOtp = value;
                },
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () async {
                  try {
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsOtp);

                    final User user =
                        (await _auth.signInWithCredential(phoneAuthCredential))
                            .user;
                    // create User data in fireStore after user successfully registered,

                    _createUser(id: user.uid, number: user.phoneNumber);

                    // navigate to home page after login
                    if (user != null) {
                      Navigator.of(context).pop();
                      //don't want come back to welcome screen after logged in
                      Navigator.pushReplacementNamed(
                          context, HomeScreen.routeName);
                    } else {
                      print('Login failed');
                    }
                  } catch (e) {
                    this.error = 'Invalid OTP';
                    notifyListeners();

                    print(e.toString());
                    Navigator.of(context).pop();
                  }
                },
                child: Text(
                  'DONE',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        });
  }

  void _createUser({String id, String number}) {
    print("_create User");
    _userServices.createUserData({
      'id': id,
      'number': number,
    });
  }
}
