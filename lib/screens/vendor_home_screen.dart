import 'package:first_firebase_flutter_project/widgets/vandor_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../provider/store_provider.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String routeName = '/vendor_home_screen';

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              iconTheme: IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: Icon(CupertinoIcons.search),
                  onPressed: () {},
                )
              ],
              title: Text(
                _store.selectedStore,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          ];
        },
        body: Column(
          children: [VendorBanner()],
        ),
      ),
    );
  }
}
