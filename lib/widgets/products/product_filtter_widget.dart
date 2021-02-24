import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_firebase_flutter_project/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/store_provider.dart';

class ProductFilterWidget extends StatefulWidget {
  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  ProductServices _services = ProductServices();

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('category.mainCategory',
            isEqualTo: _store.selectedProductCategory)
        .where('category.subCategory',
            isEqualTo: _store.selectedProductSubCategory)
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  _subCatList.add(doc['category']['subCategory']);
                });
              }),
            });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeData = Provider.of<StoreProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
        future:
            _services.category.doc(_storeData.selectedProductCategory).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (!snapshot.hasData) {
            return Container();
          }

          Map<String, dynamic> data = snapshot.data.data();
          return Container(
            height: 50,
            color: Colors.grey[400],
            child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    ActionChip(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      label: Text('All ${_storeData.selectedProductCategory}'),
                      onPressed: () {
                        //this will remove filter
                        _storeData.selectedSubCategory(null);
                      },
                      backgroundColor: Colors.white,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        // print('sanket11');
                        // print('${data['subCat'][index]['name']}');
                        return Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: _subCatList
                                  .contains(data['subCat'][index]['name'])
                              ? ActionChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  elevation: 6,
                                  label:
                                      Text('${data['subCat'][index]['name']}'),
                                  onPressed: () {
                                    _storeData.selectedSubCategory(
                                        data['subCat'][index]['name']);
                                  },
                                  backgroundColor: Colors.white,
                                )
                              : Container(),
                        );
                      },
                      itemCount: data.length,
                    )
                  ],
                )),
          );
        });
  }
}
