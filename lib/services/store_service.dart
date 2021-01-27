import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  getTopPickedStore() {
    //this will show only verified vendor
    //this will show only topPicked vendor by admin
    // this will sort the store alphabetic order
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }
}
