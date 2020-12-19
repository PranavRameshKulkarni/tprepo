import 'package:flutter/material.dart';
import 'package:flutter_complete/screens/Homescreen.dart';
import 'package:flutter_complete/screens/getting_started_screen.dart';
import 'package:flutter_complete/screens/login_screen.dart';
import 'package:flutter_complete/screens/signup_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  GlobalKey<NavigatorState> navigator;
  var status_code;
  @override
  Widget build(BuildContext context) {
//    checkToken();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: checkState(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        SignupScreen.routeName: (ctx) => SignupScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },
    );
  }

//  checkToken() async {
//    var status = 401;
//    var response = await http.get('http://127.0.0.1:8000/test/', headers: {
//      'Authorization':
//          'Token 34bc270a7bd3070004d3b2f7372fc639b9a5969bc37beb809c'
//    }).then((value) {
//      status = value.statusCode;
//    });
//
//    if (status == 200) {
//      status_code = 200;
//    } else {
//      status_code = 401;
//    }
//  }
}

class checkState extends StatefulWidget {
  @override
  _checkStateState createState() => _checkStateState();
}

class _checkStateState extends State<checkState> {
  var status;

  @override
  void initState() {
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    print('status = $status');
    return status != null && status == 200
        ? HomeScreen() //if status is 200 run the map
        : GettingStartedScreen(); //else redirect to getting started screen
  }

  checkToken() async {
    SharedPreferences sfs = await SharedPreferences.getInstance();
    var token = sfs.get('token');
    var response = await http.get('https://hackelite.herokuapp.com/test/',
        headers: {'Authorization': 'Token ' + token}).then((value) {
      print(value.body);
      setState(() {
        status = value.statusCode;
      });
    });
  }
}
