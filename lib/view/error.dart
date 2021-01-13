import 'package:flutter/material.dart';

class ErrorView extends StatefulWidget {
  ErrorView({Key key}) : super(key: key);

  @override
  _ErrorViewState createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Error Page'),
      ),
    );
  }
}
