import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login_signup/AuthServices/PrefManager.dart';
import 'package:flutter_login_signup/src/Dashboard.dart';
import 'package:flutter_login_signup/src/welcomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _prefManager = PrefManager();
   var userDatas;
  getuserData() async {
    userDatas = json.decode(await _prefManager.get("user.data", "{}"));

    print("im in profile $userDatas");
  }

  @override
  void initState() {
    getuserData();
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => userDatas.isEmpty
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => WelcomePage()))
            : Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Dashboard())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
        body: Stack(children: <Widget>[
      Container(color: Colors.white),
      Center(
          child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/smartirrigation.png"),
                  height: 180,
                  width: 180,
                ),
                SizedBox(
                  height: 30,
                ),
                CircularProgressIndicator(),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 32),
                  child: Text(
                    'Welcome to Smart Irrigation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ))
    ]));
  }
}
