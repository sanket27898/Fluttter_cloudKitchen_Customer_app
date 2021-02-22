import 'package:first_firebase_flutter_project/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../provider/store_provider.dart';

import '../services/store_service.dart';

class TopPickStore extends StatefulWidget {
  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  @override
  Widget build(BuildContext context) {
    StoreServices _storeServices = StoreServices();
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUserLoactionData(context);

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(
        _storeData.userLatitude,
        _storeData.userLongitude,
        location.latitude,
        location.longitude,
      );
      var distanceInKm = distance / 1000; //this will show in kilometer
      return distanceInKm.toStringAsFixed(2);
    }

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getTopPickedStore(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapShort) {
          if (!snapShort.hasData)
            return Center(
                child: Container(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ));
          //! now we nee to show store 0nly with in 10 km distance
          //! need to confirm even no shop near by or not
          // print(snapShort.data.docs.length);
          List shopDistance = [];
          for (int i = 0; i < snapShort.data.docs.length; i++) {
            var distance = Geolocator.distanceBetween(
              _storeData.userLatitude,
              _storeData.userLongitude,
              snapShort.data.docs[i]['location'].latitude,
              snapShort.data.docs[i]['location'].longitude,
            );
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (shopDistance[0] > 2) {
            return Container();
          }
          return Container(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 30,
                          child: Image.asset('images/like.gif'),
                        ),
                        Text(
                          'Top Store Picks For You',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Flexible(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapShort.data.docs
                            .map((DocumentSnapshot document) {
                          if (double.parse(getDistance(document['location'])) <=
                              2) {
                            //show the stores only with in 10km
                            //u can increase or discrease the distance
                            return InkWell(
                              onTap: () {
                                print(document['uid']);
                                _storeData.getSelectedStore(document,
                                    getDistance(document['location']));

                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(
                                      name: VendorHomeScreen.routeName),
                                  screen: VendorHomeScreen(),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: Image.network(
                                              document['imageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        child: Text(
                                          document['shopName'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        '${getDistance(document['location'])} Km',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            //if no stores
                            return Container();
                          }
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
