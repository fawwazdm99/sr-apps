import 'dart:io';

import 'package:flutter/material.dart';

import 'package:sr_apps/router/router.dart' as router;
import 'package:sr_apps/router/routerPage.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    HttpClient client = super.createHttpClient(context); //<<--- notice 'super'
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SR APPS',
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          color: Colors.lime[900],
        )),
        onGenerateRoute: router.generateRoute,
        initialRoute: SplashScreenViewRoute);
  }
}
