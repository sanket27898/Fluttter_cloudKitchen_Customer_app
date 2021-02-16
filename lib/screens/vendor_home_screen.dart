import 'package:first_firebase_flutter_project/widgets/category_widget.dart';
import 'package:first_firebase_flutter_project/widgets/vandor_banner.dart';
import 'package:first_firebase_flutter_project/widgets/vendor_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String routeName = '/vendor_home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: Column(
          children: [
            VendorBanner(),
            Expanded(
              child: VendorCategories(),
            ),
          ],
        ),
      ),
    );
  }
}
