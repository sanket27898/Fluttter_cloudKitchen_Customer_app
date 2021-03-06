import 'package:first_firebase_flutter_project/widgets/near_by_store.dart';
import 'package:flutter/material.dart';

import '../widgets/image_slider.dart';
import '../widgets/my_appbar.dart';
import '../widgets/top_pick_store.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/homeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [MyAppBar()];
        },
        body: ListView(
          padding: const EdgeInsets.only(top: 0),
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
      ),
    );
  }
}
