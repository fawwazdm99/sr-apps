import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_addManual.dart';
import 'package:sr_apps/view/widget/customDialog.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class AddManualView extends StatefulWidget {
  final dynamic data;
  AddManualView({Key key, this.data}) : super(key: key);

  @override
  _AddManualViewState createState() => _AddManualViewState();
}

class _AddManualViewState extends State<AddManualView> {
  dynamic bloc;
  @override
  void initState() {
    bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[900],
      appBar: AppBar(
        title: Text('Tambah Manual'),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 1.1),
            child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(50))),
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                        stream: bloc.getNim,
                        builder: (context, snapshot) {
                          return TextFormField(
                            autofocus: false,
                            onChanged: bloc.updateNim,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'NIM',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.lime[900]),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime[900], width: 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime[900], width: 2))),
                          );
                        }),
                    StreamBuilder(
                        stream: bloc.validateForm,
                        builder: (context, snapshot) {
                          return RaisedButton.icon(
                              onPressed: () async {
                                if (snapshot.hasData) {
                                  loaderDialog(
                                      context,
                                      SpinKitThreeBounce(
                                        color: Colors.lime[900],
                                      ),
                                      'wait a minute...');
                                  dynamic data =
                                      await bloc.addPresensi(widget.data['id']);
                                  if (data['error']) {
                                    return errorDialog(
                                        context, data['message']);
                                  } else {
                                    Navigator.of(context).pop();
                                    await Future.delayed(
                                        Duration(milliseconds: 100));
                                    return customDialog(
                                        context,
                                        Icon(
                                          Icons.check,
                                          color: Colors.lime[900],
                                        ),
                                        'NIM berhasil ditambahkan');
                                  }
                                } else {
                                  errorDialog(context,
                                      'Make sure you complete the form');
                                }
                              },
                              icon: Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              color: Colors.lime[900],
                              label: Text(
                                'Tambah',
                                style: TextStyle(color: Colors.white),
                              ));
                        })
                  ],
                )),
          )
        ],
      ),
    );
  }
}
