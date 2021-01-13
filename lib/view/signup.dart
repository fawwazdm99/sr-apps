import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_signup.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class SignUpView extends StatefulWidget {
  SignUpView({Key key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  static dynamic signUpBloc;
  @override
  void initState() {
    signUpBloc = Bloc();
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1975),
      lastDate: DateTime(2050),
      // selectableDayPredicate: (DateTime val) =>
      //     val.weekday == 6 || val.weekday == 7 ? true : false,
    );

    if (picked != null)
      setState(() {
        signUpBloc.updateDate(picked);
        selectedDate = picked;
      });
  }

  List _genderList = ['Laki-laki', 'Perempuan'];
  List _genderValue = ['Laki-laki', 'Perempuan'];
  List<DropdownMenuItem<String>> _genderItems;
  String _currentGender;
  List<DropdownMenuItem<String>> getDropDownGenderItems() {
    List<DropdownMenuItem<String>> items = new List();
    int counter = 0;

    for (String gender in _genderList) {
      items.add(new DropdownMenuItem(
          value: _genderValue[counter], child: new Text(gender.toString())));

      counter++;
    }
    setState(() {
      signUpBloc.updateGender(_genderValue[0]);
      _currentGender = _genderValue[0];
    });

    return items;
  }

  void changedDropDownItemGender(String selectedType) {
    setState(() {
      _currentGender = selectedType;
    });
  }

  List _divisionType;
  List _divisionValue;
  List<DropdownMenuItem<String>> _divisionItems;
  String _currentdivision;
  // @override
  // void initState() {
  //   _currentdivision = "Khatmil Qur'an";

  //   super.initState();
  // }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int counter = 0;

    for (String division in _divisionType) {
      items.add(new DropdownMenuItem(
          value: _divisionValue[counter],
          child: new Text(division.toString())));
      counter++;
    }

    return items;
  }

  void changedDropDownItem(String selectedType) {
    setState(() {
      _currentdivision = selectedType;
    });
  }

  @override
  void dispose() {
    signUpBloc.dispose();
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
                padding: EdgeInsets.all(20),
                child: Text(
                  'Daftar Dulu Yuk',
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 1.1,
                ),
                child: Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(50))),
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: signUpBloc.getNim,
                        builder: (context, snapshot) {
                          print(snapshot.data);
                          return TextFormField(
                            onChanged: signUpBloc.updateNim,
                            keyboardType: TextInputType.number,
                            initialValue: signUpBloc.getNimVal(),
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
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tanggal lahir',
                            style: TextStyle(color: Colors.lime[900]),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.lime[900],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                ),
                                StreamBuilder(
                                    stream: signUpBloc.getDate,
                                    builder: (context, snapshot) {
                                      return Text(signUpBloc.getDateConvert());
                                    }),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Text('Pilih',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.lime[900],
                            ),
                          )
                        ],
                      ),
                      StreamBuilder(
                          stream: signUpBloc.getName,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: signUpBloc.getNameVal(),
                              onChanged: signUpBloc.updateName,
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
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                            labelText: 'Jenis Kelamin',
                            contentPadding: EdgeInsets.all(0),
                            labelStyle: TextStyle(color: Colors.lime[900]),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.lime[900],
                            ))),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        items: getDropDownGenderItems(),
                        value: _currentGender,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.lime[900],
                        ),
                        onChanged: (String value) {
                          setState(() {
                            print(value);
                            signUpBloc.updateGender(value);
                            _currentGender = value;
                          });
                        },
                      ),
                      Padding(padding: EdgeInsets.all(10)),
                      StreamBuilder(
                          stream: signUpBloc.getProgramme,
                          initialData: signUpBloc.getProgrammeVal(),
                          builder: (context, snapshot) {
                            return TextFormField(
                              onChanged: signUpBloc.updateProgramme,
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
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      StreamBuilder(
                          stream: signUpBloc.getFaculty,
                          initialData: signUpBloc.getFacultyVal(),
                          builder: (context, snapshot) {
                            return TextFormField(
                              onChanged: signUpBloc.updateFaculty,
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
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      StreamBuilder(
                          stream: signUpBloc.getdivisionTypeList,
                          // initialData: [],
                          builder: (context, snapshot) {
                            if (snapshot.data.length == 0 ||
                                !snapshot.hasData) {
                              signUpBloc.getAllDivision();
                              return Container(
                                  child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.lime[900]),
                              ));
                            } else {
                              _divisionType = signUpBloc.getDivisionTypeValue();
                              _divisionValue =
                                  signUpBloc.getDivisionValueValue();
                              if (_currentdivision == null) {
                                _currentdivision = _divisionValue[0].toString();
                                signUpBloc.updateDivision(_currentdivision);
                              }

                              return DropdownButtonFormField(
                                decoration: InputDecoration(
                                    labelText: 'Bidang pembinaan',
                                    contentPadding: EdgeInsets.all(0),
                                    labelStyle:
                                        TextStyle(color: Colors.lime[900]),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                      color: Colors.lime[900],
                                    ))),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                items: getDropDownMenuItems(),
                                value: _currentdivision,
                                icon: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.lime[900],
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    print(value);
                                    signUpBloc.updateDivision(value);
                                    _currentdivision = value;
                                  });
                                },
                              );
                            }
                          }),
                      Padding(
                        padding: EdgeInsets.all(10),
                      ),
                      StreamBuilder(
                          stream: signUpBloc.getPassword,
                          initialData: signUpBloc.getPasswordVal(),
                          builder: (context, snapshot) {
                            return TextFormField(
                              obscureText: true,
                              onChanged: signUpBloc.updatePassword,
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
                        padding: EdgeInsets.all(10),
                      ),
                      StreamBuilder(
                          stream: signUpBloc.getPasswordConfirmation,
                          initialData: signUpBloc.getPasswordConfirmationVal(),
                          builder: (context, snapshot) {
                            return TextFormField(
                              obscureText: true,
                              onChanged: signUpBloc.updatePasswordConfirmation,
                              decoration: InputDecoration(
                                  errorText: snapshot.error,
                                  contentPadding: EdgeInsets.all(0),
                                  labelText: 'Konfirmasi Password',
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
                          stream: signUpBloc.validateForm,
                          builder: (context, snapshot) {
                            return RaisedButton(
                              padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                              onPressed: () async {
                                if (snapshot.hasData) {
                                  loaderDialog(
                                      context,
                                      SpinKitPumpingHeart(
                                          color: Colors.lime[900]),
                                      'Hang on there...');
                                  dynamic response = await signUpBloc.signup();
                                  print(response);
                                  if (response['error']) {
                                    Navigator.of(context).pop();
                                    errorDialog(context, response['message']);
                                  } else {
                                    Navigator.of(context).pop();
                                    loaderDialog(
                                        context,
                                        SpinKitDualRing(
                                            color: Colors.lime[900]),
                                        'Registration success! We will redirect you in a moment...');
                                    await Future.delayed(Duration(seconds: 3));
                                    Navigator.of(context).pop();
                                    await Future.delayed(
                                        Duration(milliseconds: 100));
                                    Navigator.of(context)
                                        .pushReplacementNamed(LoginViewRoute);
                                  }
                                } else {
                                  errorDialog(context,
                                      'Make sure you complete the form');
                                }
                              },
                              child: Text(
                                'Daftar',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.lime[900],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            );
                          }),
                      Padding(
                        padding: EdgeInsets.all(8),
                      ),
                      RichText(
                          text: TextSpan(
                        text: 'Batalkan',
                        style: TextStyle(color: Colors.lime[900]),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacementNamed('login');
                          },
                      ))
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class ListPembinaan extends StatefulWidget {
  ListPembinaan({Key key}) : super(key: key);

  @override
  _ListPembinaanState createState() => _ListPembinaanState();
}

class _ListPembinaanState extends State<ListPembinaan> {
  final signUpBloc = Bloc();
  List _divisionType;
  List _divisionValue;
  List<DropdownMenuItem<String>> _divisionItems;
  String _currentdivision;
  // @override
  // void initState() {
  //   _currentdivision = "Khatmil Qur'an";

  //   super.initState();
  // }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int counter = 0;

    for (String division in _divisionType) {
      items.add(new DropdownMenuItem(
          value: _divisionValue[counter],
          child: new Text(division.toString())));
      counter++;
    }

    return items;
  }

  void changedDropDownItem(String selectedType) {
    setState(() {
      _currentdivision = selectedType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: signUpBloc.getdivisionTypeList,
        // initialData: [],
        builder: (context, snapshot) {
          if (snapshot.data.length == 0 || !snapshot.hasData) {
            signUpBloc.getAllDivision();
            return Container(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.lime[900]),
            ));
          } else {
            _divisionType = signUpBloc.getDivisionTypeValue();
            _divisionValue = signUpBloc.getDivisionValueValue();
            if (_currentdivision == null) {
              _currentdivision = _divisionValue[0].toString();
              // signUpBloc.updateDivision(_currentdivision);
            }

            return DropdownButtonFormField(
              decoration: InputDecoration(
                  labelText: 'Bidang pembinaan',
                  contentPadding: EdgeInsets.all(0),
                  labelStyle: TextStyle(color: Colors.lime[900]),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.lime[900],
                  ))),
              style: TextStyle(color: Colors.black, fontSize: 14),
              items: getDropDownMenuItems(),
              value: _currentdivision,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.lime[900],
              ),
              onChanged: (String value) {
                setState(() {
                  print(value);
                  signUpBloc.updateDivision(value);
                  _currentdivision = value;
                });
              },
            );
          }
        });
  }
}
