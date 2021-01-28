import 'package:first_firebase_flutter_project/widgets/near_by_store.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

import '../widgets/image_slider.dart';
import '../widgets/my_appbar.dart';
import '../widgets/top_pick_store.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/homeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: ListView(
        children: [
          ImageSlider(),
          Container(
            color: Colors.white,
            child: TopPickStore(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: NearByStores(),
          ),
        ],
      ),
    );
  }
}
