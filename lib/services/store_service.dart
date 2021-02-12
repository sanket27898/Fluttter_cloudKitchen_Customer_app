import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference vendorbanner =
      FirebaseFirestore.instance.collection('vendorbanner');
  getTopPickedStore() {
    //this will show only verified vendor
    //this will show only topPicked vendor by admin
    // this will sort the store alphabetic order
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .where('shopOpen', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

//it will show all the store near by
  getNearByStore() {
    //this will show only verified vendor
    //this will show only topPicked vendor by admin
    // this will sort the store alphabetic order
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStorePagination() {
    //this will show only verified vendor
    //this will show only topPicked vendor by admin
    // this will sort the store alphabetic order
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName');
  }
}
