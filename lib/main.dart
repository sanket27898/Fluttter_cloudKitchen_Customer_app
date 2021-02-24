import 'package:first_firebase_flutter_project/screens/main_screen.dart';
import 'package:first_firebase_flutter_project/screens/product_details_screen.dart';

import 'package:first_firebase_flutter_project/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import './provider/store_provider.dart';
import './provider/location_provider.dart';
import './screens/landing_screen.dart';
import './screens/login_screen.dart';
import './screens/map_screen.dart';
import './provider/auth_provider.dart';
import './screens/welcome_screen.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => StoreProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primaryColor: Color(0xFF84c225),
        primaryColor: Colors.orange[400],
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
        MapScreen.routeName: (ctx) => MapScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        LandingScreen.routeName: (ctx) => LandingScreen(),
        MainScreen.routeName: (ctx) => MainScreen(),
        VendorHomeScreen.routeName: (ctx) => VendorHomeScreen(),
        ProductListScreen.routeName: (ctx) => ProductListScreen(),
        ProductdetailsScreen.routeName: (ctx) => ProductdetailsScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
