import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_login.dart';
import 'package:sr_apps/bloc/template.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  static dynamic bloc;

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
      body: Container(
        color: Colors.lime[900],
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                baseUrl + '/uploads/1%20Greeting.png'),
                            fit: BoxFit.contain)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Assalamualaikum',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                        Text(
                          'Silahkan masuk untuk melanjutkan',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 2.25),
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
                            onChanged: bloc.updateNim,
                            initialValue: bloc.getNimVal(),
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
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    StreamBuilder(
                        stream: bloc.getPassword,
                        initialData: bloc.getPasswordVal(),
                        builder: (context, snapshot) {
                          return TextFormField(
                            obscureText: true,
                            onChanged: bloc.updatePassword,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Password',
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
                    Padding(
                      padding: EdgeInsets.all(20),
                    ),
                    StreamBuilder(
                        stream: bloc.validateForm,
                        initialData: false,
                        builder: (context, snapshot) {
                          return RaisedButton(
                            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                            onPressed: () async {
                              if (snapshot.hasData) {
                                loaderDialog(
                                    context,
                                    SpinKitThreeBounce(color: Colors.lime[900]),
                                    'wait a minute...');
                                dynamic response = await bloc.login();
                                if (response['error']) {
                                  Navigator.of(context).pop();
                                  errorDialog(context, response['message']);
                                } else {
                                  // Navigator.of(context).pop();
                                  // await Future.delayed(
                                  //     Duration(milliseconds: 100));
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      HomeViewRoute,
                                      (Route<dynamic> route) => false);
                                }
                              } else {
                                errorDialog(
                                    context, 'Make sure you complete the form');
                              }
                            },
                            child: Text(
                              'Masuk',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.lime[900],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          );
                        }),
                    Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Belum punya akun? ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                                text: 'Daftar',
                                style: TextStyle(
                                    color: Colors.lime[900], fontSize: 14),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushNamed('signup');
                                  })
                          ]),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
