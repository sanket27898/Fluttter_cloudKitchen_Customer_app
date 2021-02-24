import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_flutter_project/provider/store_provider.dart';
import 'package:first_firebase_flutter_project/services/product_services.dart';
import 'package:first_firebase_flutter_project/widgets/products/product_card_widget.dart';
import 'package:first_firebase_flutter_project/widgets/products/product_filtter_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _storeProvider = Provider.of<StoreProvider>(context);
    //!here we use above _storeProvider which is same as this below line
    // var _store = Provider.of<StoreProvider>(context);

    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('category.mainCategory',
              isEqualTo: _storeProvider.selectedProductCategory)
          .where('category.subCategory',
              isEqualTo: _storeProvider.selectedProductSubCategory)
          .where('seller.sellerUid',
              isEqualTo: _storeProvider.storeDetails['uid'])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Center(child: Text("Loading..."));
        }
        if (snapshot.data.docs.isEmpty) {
          return Container(); //if no data
        }
        // print(snapshot.data);
        return Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      '${snapshot.data.docs.length} Items',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
            ListView(
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                // print(document.id);
                return ProductCard(
                  document: document,
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
