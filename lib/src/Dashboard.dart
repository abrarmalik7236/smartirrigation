import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_signup/AuthServices/PrefManager.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'loginPage.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  dynamic data;
  bool istrue = false;
  bool isLoading = false;
  final DBRef = FirebaseDatabase.instance.reference();
  fetchlocation() async {
    setState(() {
      isLoading = true;
    });
    await DBRef.once().then((DataSnapshot dataSnapshot) {
      setState(() {
        data = dataSnapshot;
        isLoading = false;
        if (data.value["automanual"] == 1) {
          istrue = false;
        } else {
          istrue = true;
        }
      });
      print("the value is ${data.value}");
    });
  }

  fetchdatatime() async {
    await DBRef.once().then((DataSnapshot dataSnapshot) {
      setState(() {
        data = dataSnapshot;
      });
      print("the value is ${data.value}");
    });
  }

  void updateData(n) async {
    setState(() {
      isLoading = true;
    });
    await DBRef.update({'automanual': n});
    setState(() {
      isLoading = false;
    });
  }

  void updatePump(n) async {
    setState(() {
      isLoading = true;
    });
    await DBRef.update({'pumponoff': n});
    setState(() {
      isLoading = false;
    });
  }

  void updateFan(n) async {
    setState(() {
      isLoading = true;
    });
    await DBRef.update({'fanonoff': n});
    setState(() {
      isLoading = false;
    });
  }

  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void initState() {
    fetchlocation();
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    PrefManager().remove("user.data");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Timer timer;
  bool status = false;
  bool status2 = false;
  bool fan = false;
  dynamic n;
  Widget build(BuildContext context) {
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchdatatime());
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image(
          image: AssetImage('assets/background.jpg'),
          fit: BoxFit.cover,
        ),
        title: Text("Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          GestureDetector(
            onTap: () {
              _signOut();
            },
            child: Chip(
                backgroundColor: Colors.red,
                label: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/background.jpg',
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 32),
                          child: Image.asset("assets/smartirrigation.png",
                              width: 100)),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 32),
                        child: Text(
                          'Welcome to Smart Irrigation',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 32),
                            child: Column(
                              children: [
                                Text(
                                  'Humidity',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${data == null ? "" : data.value["humidity"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 32),
                            child: Column(
                              children: [
                                Text(
                                  'Soil Moisture',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${data == null ? "" : data.value["soilmoisture"]}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 32),
                            child: Column(
                              children: [
                                Text(
                                  'Temperature',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    '${data == null ? "" : data.value["temperature"]}°C ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            // Padding(
                            //   padding: EdgeInsets.only(top: 10, bottom: 32),
                            //   child: Text(
                            //     'Auto Manual',
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //         color: Colors.black,
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            Padding(
                                padding: EdgeInsets.only(top: 30, bottom: 0),
                                child: automanual())
                          ]),
                          Column(children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 32),
                              child: Text(
                                'Pump',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                child: FlutterSwitch(
                              width: 125.0,
                              height: 55.0,
                              valueFontSize: 25.0,
                              toggleSize: 45.0,
                              value: status,
                              borderRadius: 30.0,
                              padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  status = val;

                                  if (status == true) {
                                    setState(() {
                                      n = 0;
                                      updatePump(n);
                                    });
                                  } else {
                                    setState(() {
                                      n = 1;
                                      updatePump(n);
                                    });
                                  }
                                  print(n);
                                });
                              },
                            )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 32),
                              child: Text(
                                'Fan',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                                child: FlutterSwitch(
                              width: 125.0,
                              height: 55.0,
                              valueFontSize: 25.0,
                              toggleSize: 45.0,
                              value: fan,
                              borderRadius: 30.0,
                              padding: 8.0,
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  fan = val;

                                  if (fan == true) {
                                    setState(() {
                                      n = 0;
                                      updateFan(n);
                                    });
                                  } else {
                                    setState(() {
                                      n = 1;
                                      updateFan(n);
                                    });
                                  }
                                  print(n);
                                });
                              },
                            )),
                          ])
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget automanual() {
    return Column(
      children: [
        Row(children: [
          Container(
            padding: EdgeInsets.only(top: 0, left: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 150,
            width: 110,
            child: Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                            color: !istrue ? Colors.grey[200] : Colors.red,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                istrue = true;
                                updateData(0);
                                updatePump(1);
                                status = false;
                              });
                            },
                            child: Text(
                              'Auto',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: !istrue ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 55,
                        width: 100,
                        decoration: BoxDecoration(
                            color: !istrue ? Colors.green : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                istrue = false;
                                //    status = '';
                                print(istrue);
                                updateData(1);
                                //updatePump(1);
                              });
                            },
                            child: Text(
                              'Manual',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: istrue ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])),
          )
        ]),
      ],
    );
  }
}
