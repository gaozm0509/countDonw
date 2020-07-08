/*
 * @Author: 高泽民 
 * @Date: 2020-07-08 16:38:55 
 * @Last Modified by: 高泽民
 * @Last Modified time: 2020-07-08 20:28:42
 */

import 'dart:async';
import 'package:date_format/date_format.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui show window;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentStamp = 0;
  String currentStampString = "00:00";

  String getShowData(int stamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(stamp);
    String reslut = formatDate(dateTime, [nn, ":", ss]);
    return reslut;
  }

  createCountDown() {
    const timeout = const Duration(seconds: 1);
    Timer.periodic(timeout, (timer) {
      currentStamp = currentStamp - 1000;
      setState(() {
        currentStampString = getShowData(currentStamp);
      });
      if (currentStamp == 0) {
        timer.cancel();
        timer = null;
      }
    });
  }

  List<Widget> listWidget() {
    List<int> list = [5, 10, 30, 60];
    List<Widget> reslut = [];
    for (var i = 0; i < list.length; i++) {
      ListTile l = ListTile(
        title: new Text(
          list[i].toString(),
          textAlign: TextAlign.center,
        ),
        onTap: () async {
          currentStamp = list[i] * 1000 * 60;
          setState(() {
            currentStampString = getShowData(currentStamp);
          });
          Navigator.pop(context);
        },
      );
      reslut.add(l);
    }
    return reslut;
  }

  showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(mainAxisSize: MainAxisSize.min, children: listWidget());
        });
  }

  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: GestureDetector(
                  onTap: () {
                    createCountDown();
                  },
                  child: Container(
                    width: MediaQueryData.fromWindow(ui.window).size.width,
                    height: MediaQueryData.fromWindow(ui.window).size.height,
                    child: Center(
                      child: Text(
                        currentStampString,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 200,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 50,
                child: GestureDetector(
                  onTap: () {
                    showPicker(context);
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
