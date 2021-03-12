import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_flutter_project/services/cart_services.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  CartServices _cart = CartServices();
  double subTotal = 0.0;
  int cartQty = 0;
  QuerySnapshot snapshot;

  Future<double> getCartTotal() async {
    var cartTotal = 0.0;
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user.uid).collection('products').get();
    if (snapshot == null) {
      return null;
    }
    snapshot.docs.forEach((docs) {
      cartTotal = cartTotal + docs.data()['total'];
    });
    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();
    return cartTotal;
  }
}
