import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_flutter_project/services/cart_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Counterforcard extends StatefulWidget {
  final DocumentSnapshot document;
  const Counterforcard(this.document);
  @override
  _CounterforcardState createState() => _CounterforcardState();
}

class _CounterforcardState extends State<Counterforcard> {
  User user = FirebaseAuth.instance.currentUser;
  CartServices _cart = CartServices();

  int _qty = 1;
  String _docId;
  bool _exist = false;
  bool _updating = false;

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document.data()['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.isNotEmpty)
                {
                  querySnapshot.docs.forEach((doc) {
                    if (doc['productId'] ==
                        widget.document.data()['productId']) {
                      //means selected product already exists in cart, so no need to add to cart again
                      setState(() {
                        _qty = doc['qty'];
                        _docId = doc.id;
                        _exist = true;
                      });
                    }
                  }),
                }
              else
                {
                  setState(() {
                    _exist = false;
                  })
                }
            });
  }

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.document.data()['productId']);
    return _exist
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshort) {
              return Container(
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.pink,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                        });
                        if (_qty == 1) {
                          _cart.removeFromCart(_docId).then((value) {
                            setState(() {
                              _updating = false;
                              _exist = false;
                            });
                          });
                          // need to check after remove
                          _cart.checkData();
                        }
                        if (_qty > 1) {
                          setState(() {
                            _qty--;
                          });
                          var total = _qty * widget.document.data()['price'];
                          _cart
                              .updateCartQty(_docId, _qty, total)
                              .then((value) {
                            setState(() {
                              _updating = false;
                            });
                          });
                        }
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Icon(
                            _qty == 1 ? Icons.delete_outline : Icons.remove,
                            color: Colors.pink,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 30,
                      color: Colors.pink,
                      child: Center(
                        child: FittedBox(
                          child: _updating
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  )),
                                )
                              : Text(
                                  _qty.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                          _qty++;
                        });
                        var total = _qty * widget.document.data()['price'];
                        _cart.updateCartQty(_docId, _qty, total).then((value) {
                          setState(() {
                            _updating = false;
                          });
                        });
                      },
                      child: Container(
                        child: Icon(
                          Icons.add,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshort) {
              return InkWell(
                onTap: () {
                  EasyLoading.show(status: 'Adding to cart');
                  _cart.checkSeller().then((shopName) {
                    print(shopName);
                    if (shopName ==
                        widget.document.data()['seller']['shopName']) {
                      //product from same seller
                      setState(() {
                        _exist = true;
                      });
                      _cart.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess('Added to cart');
                      });
                      return;
                    }
                    if (shopName == null) {
                      setState(() {
                        _exist = true;
                      });
                      _cart.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess('Added to cart');
                      });
                      return;
                    }
                    if (shopName !=
                        widget.document.data()['seller']['shopName']) {
                      //product fom different seller

                      EasyLoading.dismiss();
                      showDialog(shopName);
                      return;
                    }
                  });
                },
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 30,
                        right: 30,
                      ),
                      child: Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            });
  }

  showDialog(shopName) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Replace Cart item?'),
            content: Text(
                "Your cart contains items from $shopName. Do you want to discard the selection and add items from ${widget.document.data()['seller']['shopName']}"),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  //delete existing product from cart
                  _cart.deleteCart().then((value) {
                    _cart.addToCart(widget.document).then((value) {
                      setState(() {
                        _exist = true;
                      });
                      Navigator.pop(context);
                    });
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
