import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_flutter_project/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/store_provider.dart';

class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _services = ProductServices();
  List _catList = [];
  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                print(doc["category"]['mainCategory']);
                //add all this in a list
                setState(() {
                  _catList.add(doc['category']['mainCategory']);
                });
              }),
            });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong...'),
          );
        }
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }
        if (_catList.length == 0) {
          return Container();
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return _catList.contains(document.data()['name'])
                  ? //only if _catList contain the category from selected vendor
                  Container(
                      width: 120,
                      height: 150,
                      child: Card(
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              child: Image.network(
                                document.data()['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8),
                              child: Text(
                                document.data()['name'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Text('');
            }).toList(),
          ),
        );
      },
    );
  }
}
