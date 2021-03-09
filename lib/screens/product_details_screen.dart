import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_flutter_project/widgets/products/bootom_sheet_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductdetailsScreen extends StatelessWidget {
  static const String routeName = '/product_screen';

  final DocumentSnapshot document;
  ProductdetailsScreen({@required this.document});

  @override
  Widget build(BuildContext context) {
    var offer = ((document.data()['comparedPrice'] - document.data()['price']) /
            document.data()['comparedPrice']) *
        100;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search),
            onPressed: () {},
          )
        ],
      ),
      bottomSheet: BottomSheetContainer(document),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(.3),
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 2, bottom: 2),
                      child: Text(
                        document.data()['brand'],
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              document.data()['productName'],
              style: TextStyle(fontSize: 22),
            ),
            SizedBox(
              height: 10,
            ),
            Text(document.data()['weight']),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Rs ${document.data()['price'].toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                if (offer > 0) //if offer available only
                  Text(
                    'Rs ${document.data()['comparedPrice'].toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (offer > 0) //if offer available only
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 3, bottom: 3),
                      child: Text(
                        '${offer.toStringAsFixed(0)}% OFF',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag: 'product ${document.data()['productName']}',
                child: Image.network(
                  document.data()['productImage'],
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 6,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  'About this Product',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
              child: ExpandableText(
                document.data()['description'],
                expandText: 'View more',
                collapseText: 'View less',
                maxLines: 2,
                linkColor: Colors.blue,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  'Other Product Info',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.grey[400],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SKU : ${document.data()['sku']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'Seller : ${document.data()['seller']['shopName']}',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }

  Future<void> saveForLater() {
    CollectionReference _favourite =
        FirebaseFirestore.instance.collection('favourites');
    print(document.data());
    User user = FirebaseAuth.instance.currentUser;
    return _favourite.add({
      'product': document.data(),
      'customerId': user.uid,
    });
  }
}
