import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_addGuest.dart';
import 'package:sr_apps/view/widget/customDialog.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class AddGuestView extends StatefulWidget {
  final dynamic data;
  AddGuestView({Key key, this.data}) : super(key: key);

  @override
  _AddGuestViewState createState() => _AddGuestViewState();
}

class _AddGuestViewState extends State<AddGuestView> {
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
        title: Text('Tambah Tamu'),
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
                        stream: bloc.getName,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateName,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Nama',
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
                        stream: bloc.getFaculty,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateFaculty,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Fakultas',
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
                        stream: bloc.getStudyProgram,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateStudyProgram,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Program Studi',
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
                          return RaisedButton(
                            onPressed: () async {
                              if (snapshot.hasData) {
                                loaderDialog(
                                    context,
                                    SpinKitThreeBounce(
                                      color: Colors.lime[900],
                                    ),
                                    'wait a minute...');

                                dynamic data = await bloc
                                    .addGuest(widget.data['agenda_id']);
                                if (data['error']) {
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
                                      'Tamu berhasil ditambahkan');
                                }
                              } else {
                                return errorDialog(context,
                                    'Pastikan kamu mengisi form dengan lengkap');
                              }
                            },
                            color: Colors.lime[900],
                            child: Text(
                              'Tambahkan',
                              style: TextStyle(color: Colors.white),
                            ),
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
