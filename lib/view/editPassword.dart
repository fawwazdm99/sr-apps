import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_editPassword.dart';
import 'package:sr_apps/view/widget/customDialog.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class EditPasswordView extends StatefulWidget {
  EditPasswordView({Key key}) : super(key: key);

  @override
  _EditPasswordViewState createState() => _EditPasswordViewState();
}

class _EditPasswordViewState extends State<EditPasswordView> {
  static dynamic bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[900],
      appBar: AppBar(
        title: Text('Ubah Password'),
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
                        stream: bloc.getOldPassword,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateOldPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Password lama',
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
                    Padding(padding: EdgeInsets.all(10)),
                    StreamBuilder(
                        stream: bloc.getNewPassword,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateNewPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Password baru',
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
                    Padding(padding: EdgeInsets.all(10)),
                    StreamBuilder(
                        stream: bloc.getNewConfirmationPassword,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateNewConfirmationPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Konfirmasi password baru',
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
                    Padding(padding: EdgeInsets.all(5)),
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

                                dynamic data = await bloc.updatePassword();
                                if (data['error']) {
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      Duration(milliseconds: 100));
                                  return errorDialog(context, data['message']);
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
                                      'Password berhasil diubah');
                                }
                              } else {
                                return errorDialog(context,
                                    'Pastikan kamu mengisi form dengan lengkap');
                              }
                            },
                            color: Colors.lime[900],
                            label: Text(
                              'Ubah',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          );
                        })
                  ],
                )),
          )
        ],
      ),
    );
  }
}
