import 'package:first_firebase_flutter_project/provider/location_provider.dart';
import 'package:first_firebase_flutter_project/screens/login_screen.dart';
import 'package:first_firebase_flutter_project/screens/map_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

import './provider/auth_provider.dart';
import './screens/welcome_screen.dart';
import './screens/home_screen.dart';
import 'screens/splash_screen.dart';

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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.orange),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        WelcomeScreen.routeName: (ctx) => WelcomeScreen(),
        MapScreen.routeName: (ctx) => MapScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
      },
    );
  }
}
