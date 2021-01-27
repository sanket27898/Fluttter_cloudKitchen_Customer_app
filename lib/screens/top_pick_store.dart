import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:geolocator/geolocator.dart';

import '../services/user_services.dart';
import '../services/store_service.dart';

import '../screens/welcome_screen.dart';

class TopPickStore extends StatefulWidget {
  @override
  _TopPickStoreState createState() => _TopPickStoreState();
}

class _TopPickStoreState extends State<TopPickStore> {
  StoreServices _storeServices = StoreServices();
  UserServices _userServices = UserServices();
  User user = FirebaseAuth.instance.currentUser;
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;

  //need to find user LatLong Then Can Calculate distance

  @override
  void initState() {
    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        if (mounted) {
          setState(() {
            _userLatitude = result.data()['latitude'];
            _userLongitude = result.data()['longitude'];
          });
        }
      } else {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      }
    });
    super.initState();
  }

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
      _userLatitude,
      _userLongitude,
      location.latitude,
      location.longitude,
    );
    var distanceInKm = distance / 1000; //this will show in kilometer
    return distanceInKm.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
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
          print(snapShort.data.docs.length);
          List shopDistance = [];
          for (int i = 0; i < snapShort.data.docs.length; i++) {
            var distance = Geolocator.distanceBetween(
              _userLatitude,
              _userLongitude,
              snapShort.data.docs[i]['location'].latitude,
              snapShort.data.docs[i]['location'].longitude,
            );
            var distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (shopDistance[0] > 10) {
            return Container();
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Column(
              children: [
                Row(
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
                Container(
                  child: Flexible(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          snapShort.data.docs.map((DocumentSnapshot document) {
                        if (double.parse(getDistance(document['location'])) <=
                            10) {
                          //show the stores only with in 10km
                          //u can increase or discrease the distance
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: 80,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: Card(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
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
                                    '${getDistance(document['location'])}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
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
          );
        },
      ),
    );
  }
}
