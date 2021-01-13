import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_editProfile.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/view/widget/customDialog.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  final dynamic data;
  EditProfileView({Key key, this.data}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  dynamic bloc;
  String bidang_id;
  File _image;
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

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      bloc.updatePicture(image.path);
      bloc.updateIsUpdatePhoto(true);
      _image = image;
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

    return items;
  }

  void changedDropDownItemGender(String selectedType) {
    setState(() {
      _currentGender = selectedType;
    });
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
        bloc.updateDate(picked);
        selectedDate = picked;
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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lime[900],
        appBar: AppBar(
          elevation: 0,
          title: Text('Edit Profile'),
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
                child: StreamBuilder(
                    stream: bloc.getIsLoaded,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        bloc.getPreferencesData();
                        return Text('');
                      } else {
                        print(snapshot.data);
                        return Column(
                          children: <Widget>[
                            Builder(builder: (context) {
                              if (_image == null &&
                                  snapshot.data['picture'] == null) {
                                return CircleAvatar(
                                  backgroundColor: Colors.lime[900],
                                  radius: 50,
                                );
                              } else if (_image == null &&
                                  snapshot.data['picture'] != null) {
                                return CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(snapshot.data['picture']),
                                  radius: 50,
                                );
                              } else if (_image != null) {
                                return CircleAvatar(
                                  backgroundImage: FileImage(_image),
                                  backgroundColor: Colors.purple,
                                  radius: 50,
                                );
                              }
                            }),
                            RaisedButton.icon(
                                onPressed: () async {
                                  await getImage();
                                },
                                color: Colors.lime[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Pilih foto',
                                  style: TextStyle(color: Colors.white),
                                )),
                            StreamBuilder(
                                stream: bloc.getName,
                                initialData: snapshot.data['name'],
                                builder: (context, snapshot) {
                                  print(snapshot.data);
                                  return TextFormField(
                                    initialValue: snapshot.data.toString(),
                                    onChanged: bloc.updateName,
                                    decoration: InputDecoration(
                                        errorText: snapshot.error,
                                        contentPadding: EdgeInsets.all(0),
                                        labelText: 'Nama',
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lime[900]),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lime[900],
                                                width: 1)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lime[900],
                                                width: 2))),
                                  );
                                }),
                            Padding(padding: EdgeInsets.all(10)),
                            StreamBuilder(
                                stream: bloc.getGender,
                                initialData: snapshot.data['jenis_kelamin'],
                                builder: (context, snapshot) {
                                  if (_currentGender == null) {
                                    print(snapshot.data);
                                    _currentGender = snapshot.data.toString();
                                    bloc.updateGender(_currentGender);
                                  }
                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Jenis Kelamin',
                                        contentPadding: EdgeInsets.all(0),
                                        labelStyle:
                                            TextStyle(color: Colors.lime[900]),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                          color: Colors.lime[900],
                                        ))),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    items: getDropDownGenderItems(),
                                    value: snapshot.data.toString(),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.lime[900],
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        print(value);
                                        bloc.updateGender(value);
                                        _currentGender = value;
                                      });
                                    },
                                  );
                                }),
                            Padding(padding: EdgeInsets.all(5)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Tanggal Lahir',
                                  style: TextStyle(
                                      color: Colors.lime[900], fontSize: 12),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    StreamBuilder(
                                        stream: bloc.getDate,
                                        initialData: snapshot.data['date'],
                                        builder: (context, snapshot) {
                                          print(snapshot.data);
                                          return Text(bloc
                                              .getDateConvert(snapshot.data));
                                        }),
                                    RaisedButton.icon(
                                      onPressed: () {
                                        _selectDate(context);
                                      },
                                      color: Colors.lime[900],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      icon: Icon(
                                        Icons.calendar_today,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      label: Text(
                                        'Pilih',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Padding(padding: EdgeInsets.all(5)),
                            Padding(padding: EdgeInsets.all(5)),
                            StreamBuilder(
                                stream: bloc.getStudyProgram,
                                initialData: snapshot.data['studyProgram'],
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    initialValue: snapshot.data.toString(),
                                    onChanged: bloc.updateStudyProgram,
                                    decoration: InputDecoration(
                                        errorText: snapshot.error,
                                        contentPadding: EdgeInsets.all(0),
                                        labelText: 'Program Studi',
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lime[900]),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lime[900],
                                                width: 1)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lime[900],
                                                width: 2))),
                                  );
                                }),
                            Padding(padding: EdgeInsets.all(5)),
                            StreamBuilder(
                                stream: bloc.getFaculty,
                                initialData: snapshot.data['faculty'],
                                builder: (context, snapshot) {
                                  return TextFormField(
                                    initialValue: snapshot.data.toString(),
                                    onChanged: bloc.updateFaculty,
                                    decoration: InputDecoration(
                                        errorText: snapshot.error,
                                        contentPadding: EdgeInsets.all(0),
                                        labelText: 'Fakultas',
                                        labelStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.lime[900]),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lime[900],
                                                width: 1)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.lime[900],
                                                width: 2))),
                                  );
                                }),
                            Padding(padding: EdgeInsets.all(10)),
                            StreamBuilder(
                                stream: bloc.getdivisionTypeList,
                                // initialData: [],
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    bloc.getAllDivision();
                                    return Container(
                                        child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.lime[900]),
                                    ));
                                  } else {
                                    _divisionType = bloc.getDivisionTypeValue();
                                    _divisionValue =
                                        bloc.getDivisionValueValue();
                                    if (_currentdivision == null) {
                                      _currentdivision =
                                          widget.data['bidang_id'];
                                      bloc.updateDivision(_currentdivision);
                                    }

                                    return DropdownButtonFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Bidang pembinaan',
                                          contentPadding: EdgeInsets.all(0),
                                          labelStyle: TextStyle(
                                              color: Colors.lime[900]),
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
                                          bloc.updateDivision(value);
                                          _currentdivision = value;
                                        });
                                      },
                                    );
                                  }
                                }),
                            Padding(padding: EdgeInsets.all(10)),
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
                                            'Wait a minute...');
                                        dynamic data =
                                            await bloc.updateProfile();

                                        if (data['error']) {
                                          Navigator.of(context).pop();
                                          await Future.delayed(
                                              Duration(milliseconds: 100));
                                          errorDialog(context, data['message']);
                                        } else {
                                          await bloc.setNewPrefs();
                                          Navigator.of(context).pop();
                                          await Future.delayed(
                                              Duration(milliseconds: 100));
                                          loaderDialog(
                                              context,
                                              SpinKitDualRing(
                                                  color: Colors.lime[900]),
                                              'Profil berhasil diedit \n We will redirect you in a moment');
                                          await Future.delayed(
                                              Duration(seconds: 3));
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  HomeViewRoute,
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }
                                      } else {
                                        errorDialog(context,
                                            'Pastikan kamu mengisi form dengan lengkap');
                                      }
                                    },
                                    color: Colors.lime[900],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      'Simpan',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                })
                          ],
                        );
                      }
                    }),
              ),
            )
          ],
        ));
  }
}
