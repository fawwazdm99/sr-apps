import 'package:flutter/material.dart';

customDialog(BuildContext context, Widget loaderIcon, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Container(width: 75, height: 50, child: loaderIcon),
              Padding(padding: EdgeInsets.all(5)),
              Expanded(
                child: Text(
                  message,
                  overflow: TextOverflow.fade,
                  maxLines: 3,
                ),
              )
            ],
          ),
        );
      });
}
