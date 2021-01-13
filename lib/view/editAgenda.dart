import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_editAgenda.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/view/widget/customDialog.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class EditAgendView extends StatefulWidget {
  final dynamic data;
  EditAgendView({Key key, this.data}) : super(key: key);

  @override
  _EditAgendViewState createState() => _EditAgendViewState();
}

class _EditAgendViewState extends State<EditAgendView> {
  static dynamic bloc = Bloc();

  DateTime selectedDateStart = bloc.getDateStartVal();
  TimeOfDay selectedTimeStart = bloc.getTimeStartVal();
  Future<Null> _selectDateStart(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: bloc.getDateStartVal(),
      firstDate: DateTime(1975),
      lastDate: DateTime(2050),
      // selectableDayPredicate: (DateTime val) =>
      //     val.weekday == 6 || val.weekday == 7 ? true : false,
    );

    if (picked != null)
      setState(() {
        bloc.updateDateStart(picked);
        bloc.updateDateEnd(picked);
        selectedDateStart = picked;
        _selectTimeStart(context);
        // selectedDateStart = picked;
      });
  }

  Future<Null> _selectTimeStart(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: bloc.getTimeStartVal());
    if (picked != null)
      setState(() {
        bloc.updateTimeStart(picked);
        int hour = picked.hour + 1;
        int minute = picked.minute;
        TimeOfDay newTimeEnd = TimeOfDay(hour: hour, minute: minute);
        bloc.updateTimeEnd(newTimeEnd);

        selectedTimeStart = picked;
        selectedTimeEnd = newTimeEnd;

        // selectedDateStart = picked;
      });
  }

  DateTime selectedDateEnd = bloc.getDateEndVal();
  TimeOfDay selectedTimeEnd = bloc.getTimeEndVal();
  Future<Null> _selectDateEnd(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: bloc.getDateEndVal(),
      firstDate: DateTime(1975),
      lastDate: DateTime(2050),
      // selectableDayPredicate: (DateTime val) =>
      //     val.weekday == 6 || val.weekday == 7 ? true : false,
    );

    if (picked != null)
      setState(() {
        bloc.updateDateEnd(picked);
        selectedDateEnd = picked;
        _selectTimeEnd(context);
        // selectedDateStart = picked;
      });
  }

  Future<Null> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: bloc.getTimeEndVal());
    if (picked != null)
      setState(() {
        bloc.updateTimeEnd(picked);
        selectedTimeEnd = picked;

        // selectedDateStart = picked;
      });
  }

  List _divisionType;
  List _divisionValue;
  List<DropdownMenuItem<String>> _divisionItems;
  String _currentDivision;
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
          value: _divisionValue[counter], child: new Text(division)));
      counter++;
    }

    return items;
  }

  void changedDropDownItem(String selectedType) {
    setState(() {
      _currentDivision = selectedType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[900],
      appBar: AppBar(
        title: Text('Edit Agenda'),
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: bloc.getEditData,
          builder: (context, snapshot) {
            print(snapshot.data);
            if (!snapshot.hasData) {
              bloc.insertAllEditAgenda(
                  widget.data['title'],
                  widget.data['date_start'],
                  widget.data['time_start'],
                  widget.data['date_end'],
                  widget.data['time_end'],
                  widget.data['location'],
                  widget.data['pengurus_nim']);
              return Text('');
            } else {
              return ListView(
                children: <Widget>[
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height / 1.1),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: <Widget>[
                          // ListAgendaCategory(),
                          StreamBuilder(
                              stream: bloc.getdivisionTypeList,
                              initialData: [],
                              builder: (context, snapshot) {
                                if (snapshot.data.length == 0 ||
                                    !snapshot.hasData) {
                                  bloc.getAllAgendaCategory();
                                  return Container(
                                      child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.lime[900]),
                                  ));
                                } else {
                                  _divisionType = bloc.getDivisionTypeValue();
                                  _divisionValue = bloc.getDivisionValueValue();
                                  if (_currentDivision == null) {
                                    _currentDivision =
                                        widget.data['category_id'];
                                    bloc.updateAgendaCategory(_currentDivision);
                                  }

                                  return DropdownButtonFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Kategori Agenda',
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
                                    value: _currentDivision,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.lime[900],
                                    ),
                                    onChanged: (String value) {
                                      setState(() {
                                        print(value);
                                        bloc.updateAgendaCategory(value);
                                        _currentDivision = value;
                                      });
                                    },
                                  );
                                }
                              }),
                          Padding(padding: EdgeInsets.all(10)),
                          StreamBuilder(
                              stream: bloc.getAgenda,
                              initialData: widget.data['title'],
                              builder: (context, snapshot) {
                                print(snapshot.data);
                                if (!snapshot.hasData) {
                                  return Text('');
                                } else {
                                  return TextFormField(
                                    onChanged: bloc.updateAgenda,
                                    initialValue: snapshot.data,
                                    decoration: InputDecoration(
                                        errorText: snapshot.error,
                                        contentPadding: EdgeInsets.all(0),
                                        labelText: 'Nama Agenda',
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
                                }
                              }),
                          Padding(padding: EdgeInsets.all(10)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Waktu Mulai',
                                  style: TextStyle(color: Colors.lime[900])),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.lime[900],
                                        ),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            StreamBuilder(
                                                stream: bloc.getDateStart,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                        bloc.getDateConvert(
                                                            snapshot.data));
                                                  } else {
                                                    return Text('');
                                                  }
                                                }),
                                            StreamBuilder(
                                                stream: bloc.getTimeStart,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                        bloc.getTimeConvert(
                                                            snapshot.data));
                                                  } else {
                                                    return Text('');
                                                  }
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      _selectDateStart(context);
                                    },
                                    child: Text('Pilih',
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.lime[900],
                                  )
                                ],
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Waktu Selesai',
                                style: TextStyle(color: Colors.lime[900]),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          color: Colors.lime[900],
                                        ),
                                        Padding(padding: EdgeInsets.all(5)),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            StreamBuilder(
                                                stream: bloc.getDateEnd,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                        bloc.getDateConvert(
                                                            snapshot.data));
                                                  } else {
                                                    return Text('');
                                                  }
                                                }),
                                            StreamBuilder(
                                                stream: bloc.getTimeEnd,
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                        bloc.getTimeConvert(
                                                            snapshot.data));
                                                  } else {
                                                    return Text('');
                                                  }
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      _selectDateEnd(context);
                                    },
                                    child: Text('Pilih',
                                        style: TextStyle(color: Colors.white)),
                                    color: Colors.lime[900],
                                  )
                                ],
                              ),
                            ],
                          ),
                          StreamBuilder(
                              stream: bloc.getLocation,
                              initialData: widget.data['location'],
                              builder: (context, snapshot) {
                                return TextFormField(
                                  onChanged: bloc.updateLocation,
                                  initialValue: snapshot.data.toString(),
                                  decoration: InputDecoration(
                                      errorText: snapshot.error,
                                      prefixIcon: Icon(
                                        Icons.location_on,
                                        color: Colors.lime[900],
                                      ),
                                      contentPadding: EdgeInsets.all(0),
                                      labelText: 'Tambah Lokasi',
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

                          Padding(padding: EdgeInsets.all(10)),
                          StreamBuilder(
                              stream: bloc.validateForm,
                              builder: (context, snapshot) {
                                return RaisedButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () async {
                                    if (snapshot.hasData) {
                                      loaderDialog(
                                          context,
                                          SpinKitThreeBounce(
                                              color: Colors.lime[900]),
                                          'on working...');
                                      dynamic response =
                                          await bloc.updateAgendaApi(
                                              widget.data['pengurus_nim'],
                                              widget.data['id']);
                                      if (response['error']) {
                                        Navigator.of(context).pop();
                                        errorDialog(
                                            context, response['message']);
                                      } else {
                                        print(response['data']);
                                        Navigator.of(context).pop();
                                        await Future.delayed(
                                            Duration(milliseconds: 100));
                                        loaderDialog(
                                            context,
                                            SpinKitDualRing(
                                                color: Colors.lime[900]),
                                            'Agenda berhasil diedit \n We will redirect you in a moment');
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
                                          'Make sure you complete the form');
                                    }
                                  },
                                  icon: Icon(Icons.check, color: Colors.white),
                                  color: Colors.lime[900],
                                  label: Text(
                                    'Selesai',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
