import 'package:flutter/material.dart';
import 'package:flutter_complete/screens/Homescreen.dart';
import 'package:flutter_complete/screens/getting_started_screen.dart';
import 'package:flutter_complete/screens/login_screen.dart';
import 'package:flutter_complete/screens/signup_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GettingStartedScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },
    );
  }
}
