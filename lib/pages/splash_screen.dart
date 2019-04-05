import 'dart:async';
import 'dart:io';

import 'package:kope/utils/flutkart.dart';
import 'package:kope/utils/my_navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _connected = false;
  bool _isFirst = true;
  SharedPreferences prefs;
  bool isFirst = true;
  String userId = null;

  @override
  void initState() {
    super.initState();
    init();
    Timer(Duration(seconds: 5), (){ _checkConnection();});
  }
  void init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isFirst = (prefs.getBool('isFirst') ?? true);
      userId = (prefs.getString('userId') ?? null);
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
         //  Container(
         //   decoration: BoxDecoration(color: Colors.blueAccent,
          //       image: DecorationImage(image: AssetImage("assets/images/back.jpg"), fit: BoxFit.cover)
         //  ),
         // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child: FlutterLogo(size: 70.0,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Text(
                        Flutkart.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _isFirst == true ? CircularProgressIndicator() : (
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.white,),
                          onPressed: (){
                            print(_connected);
                            _checkConnection();
                          },
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      _isFirst == true ? Flutkart.store : Flutkart.error,
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 10.0,
                          color: Colors.black),
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _checkConnection(){
    isConnected().then((bool value){
      if(value == true){
        if (isFirst) {
          MyNavigator.goReplace(context, "/intro");
//          MyNavigator.goReplace(context, "/home");
        } else {
          userId == null
              ? MyNavigator.goReplace(context, "/login")
              : MyNavigator.goReplace(context, "/home");
        }
      }
    }).catchError((Error e)=>print(e));
  }

  void retry(){
    setState(() {
      _isFirst = false;
    });
  }

  Future<bool> isConnected() async{
    _connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _connected = true;
      }
    } on SocketException catch (_) {
      print('not connected');
    }
    _isFirst = false;
    setState(() {

    });
    return _connected;
  }
}
