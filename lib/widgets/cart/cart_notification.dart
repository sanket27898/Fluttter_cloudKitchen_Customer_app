import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_flutter_project/screens/cart_screen.dart';
import 'package:first_firebase_flutter_project/services/cart_services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartNotofication extends StatefulWidget {
  @override
  _CartNotoficationState createState() => _CartNotoficationState();
}

class _CartNotoficationState extends State<CartNotofication> {
  CartServices _cart = CartServices();
  DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    _cartProvider.getCartTotal();
    _cart.getShopName().then((value) {
      setState(() {
        document = value;
      });
    });
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: InkWell(
          onTap: () {
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: CartScreen.routeName),
              screen: CartScreen(document: document),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${_cartProvider.cartQty}  |  ${_cartProvider.cartQty == 1 ? 'Item' : 'Items'}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (document.exists)
                      Text(
                        "From ${document.data()['shopName']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Text(
                      'View Cart',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
