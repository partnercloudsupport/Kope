import 'package:kope/pages/home/home_screen.dart';
import 'package:kope/pages/intro_screen.dart';
import 'package:kope/pages/login/login_screen.dart';
import 'package:kope/pages/login/signUp_screen.dart';
import 'package:kope/pages/login/validation_number_screen.dart';
import 'package:kope/pages/profile/profile_screen.dart';
import 'package:kope/pages/splash_screen.dart';
import 'package:flutter/material.dart';

var routes = <String, WidgetBuilder>{
  "/home": (BuildContext context) => HomeScreen(),
  "/intro": (BuildContext context) => IntroScreen(),
  "/login": (BuildContext context) => LoginScreen(),
  "/sign": (BuildContext context) => SignScreen(),
  "/validation": (BuildContext context) => ValidationPhoneNumber(),
  "/profile": (BuildContext context) => ProfileScreen()
};
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.blue,
            buttonColor: Colors.blue,
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            )
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: routes);
  }
}
