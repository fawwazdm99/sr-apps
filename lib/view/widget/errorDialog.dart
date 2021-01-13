import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

errorDialog(BuildContext context, String message) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text('Opps!'),
          content: Text(message),
        );
      });
}
