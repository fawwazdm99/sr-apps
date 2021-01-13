import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sr_apps/router/routerPage.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key key}) : super(key: key);

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigatePage);
  }

  void navigatePage() async {
    final prefs = await SharedPreferences.getInstance();
    String nim = await prefs.getString('nim');

    if (nim != null) {
      Navigator.of(context).pushReplacementNamed(HomeViewRoute);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginViewRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150,
              child: Image(
                image: AssetImage('assets/img/logo-sr.png'),
                fit: BoxFit.contain,
              ),
            ),
            Padding(padding: EdgeInsets.all(10)),
            Text(
              'SR APPS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            )
          ],
        ),
      )),
    );
  }
}
