import 'package:first_firebase_flutter_project/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../services/user_services.dart';
// import '../services/store_service.dart';

class StoreProvider with ChangeNotifier {
  // StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var userLatitude = 0.0;
  var userLongitude = 0.0;
  String selectedStore;
  String selectedStoreId;

  getSelectedStore(storeName, storeId) {
    this.selectedStore = storeName;
    this.selectedStoreId = storeId;
    notifyListeners();
  }

  Future<void> getUserLoactionData(context) async {
    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        this.userLatitude = result.data()['latitude'];
        this.userLongitude = result.data()['longitude'];
        notifyListeners();
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      }
    });
  }
}
