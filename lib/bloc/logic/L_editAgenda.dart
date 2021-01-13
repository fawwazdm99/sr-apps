import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../repository.dart';

class Bloc {
  final _repository = Repository();
  final _agenda = BehaviorSubject<String>.seeded('nama');
  final _dateStart = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _timeStart = BehaviorSubject<TimeOfDay>.seeded(TimeOfDay.now());
  final _dateEnd = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _timeEnd = BehaviorSubject<TimeOfDay>.seeded(TimeOfDay.now());
  final _location = BehaviorSubject<String>();
  final _agendaCategory = BehaviorSubject<String>();

  final _divisionTypeList = BehaviorSubject<List>.seeded([]);
  final _divisionValueList = BehaviorSubject<List>.seeded([]);
  final _editData = BehaviorSubject<bool>();

  //stream
  Stream<String> get getAgenda => _agenda.stream.transform(validateAgenda);
  Stream<String> get getLocation =>
      _location.stream.transform(validateLocation);
  Stream<DateTime> get getDateStart => _dateStart.stream;
  Stream<TimeOfDay> get getTimeStart => _timeStart.stream;
  Stream<DateTime> get getDateEnd => _dateEnd.stream;
  Stream<TimeOfDay> get getTimeEnd => _timeEnd.stream;
  Stream<bool> get validateForm =>
      CombineLatestStream([getLocation], ([getLocation]) => true);
  Stream<List> get getdivisionTypeList => _divisionTypeList.stream;

  Stream<bool> get getEditData => _editData.stream;

  //add
  Function(String) get updateAgenda => _agenda.sink.add;
  Function(DateTime) get updateDateStart => _dateStart.sink.add;
  Function(TimeOfDay) get updateTimeStart => _timeStart.sink.add;
  Function(DateTime) get updateDateEnd => _dateEnd.sink.add;
  Function(TimeOfDay) get updateTimeEnd => _timeEnd.sink.add;
  Function(String) get updateLocation => _location.sink.add;
  Function(String) get updateAgendaCategory => _agendaCategory.sink.add;
  Function(List) get updateDivisionTypeList => _divisionTypeList.sink.add;
  Function(List) get updateDivisionValueList => _divisionValueList.sink.add;

  Function(bool) get updateEditData => _editData.sink.add;

  //function
  Future insertAllEditAgenda(
      String title,
      DateTime dateStart,
      TimeOfDay timeStart,
      DateTime dateEnd,
      TimeOfDay timeEnd,
      String location,
      String pengurus_nim) async {
    updateAgenda(title);
    updateDateStart(dateStart);
    updateTimeStart(timeStart);
    updateDateEnd(dateEnd);
    updateTimeEnd(timeEnd);
    updateLocation(location);

    updateEditData(true);
  }

  Future updateAgendaApi(String pengurus_nim, String id) async {
    String agenda_category = _agendaCategory.value;
    String title = _agenda.value;
    String location = _location.value;
    String start_at = getDateConvertApi(_dateStart.value, _timeStart.value);
    String end_at = getDateConvertApi(_dateEnd.value, _timeEnd.value);
    dynamic data = {
      'id': id,
      'pengurus_nim': pengurus_nim,
      'agenda_category': agenda_category,
      'title': title,
      'location': location,
      'start_at': start_at,
      'end_at': end_at
    };
    print(data);
    dynamic res = _repository.updateAgenda(data);
    return res;
  }

  Future getAllAgendaCategory() async {
    dynamic res = await _repository.getAllAgendaCategory();
    List divisionType = [];
    List divisionValue = [];

    for (var item in res['data']) {
      divisionType.add(item['name']);
      divisionValue.add(item['id']);
    }
    updateDivisionTypeList(divisionType);
    updateDivisionValueList(divisionValue);
    return res;
  }

  getDateConvertApi(DateTime date, TimeOfDay time) {
    var day = date.day;
    var month = date.month;
    var year = date.year;
    var hour = time.hour;
    var minute = time.minute;

    String newMonth = month.toString();
    String newDay = day.toString();
    String newHour = hour.toString();
    String newMinute = minute.toString();
    if (month < 10) {
      newMonth = '0' + month.toString();
    }
    if (day < 10) {
      newDay = '0' + day.toString();
    }
    if (hour < 10) {
      newHour = '0' + hour.toString();
    }
    if (minute < 10) {
      newMinute = '0' + minute.toString();
    }
    return year.toString() +
        '-' +
        newMonth +
        '-' +
        newDay +
        ' ' +
        newHour +
        ':' +
        newMinute;
  }

  getDivisionTypeValue() {
    return _divisionTypeList.value;
  }

  getDivisionValueValue() {
    return _divisionValueList.value;
  }

  getCurrentDivisionValue() {
    return _divisionTypeList.value[0].toString();
  }

  getDateStartVal() {
    return _dateStart.value;
  }

  getDateEndVal() {
    return _dateEnd.value;
  }

  getTimeStartVal() {
    return _timeStart.value;
  }

  getTimeEndVal() {
    return _timeEnd.value;
  }

  getDateConvert(date) {
    var stringMonth = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    var day = date.day;
    var month = date.month;
    var year = date.year;
    var hour = date.hour;
    var minute = date.minute;
    String newMonth = stringMonth[month - 1];
    String newDay = day.toString();
    return newDay + ' ' + newMonth + ' ' + year.toString();
  }

  getTimeConvert(TimeOfDay time) {
    var hour = time.hour;
    var minute = time.minute;
    String newHour = hour.toString();
    String newMinute = minute.toString();
    if (hour < 10) {
      newHour = '0' + hour.toString();
    } else {
      newHour = hour.toString();
    }
    if (minute < 10) {
      newMinute = '0' + minute.toString();
    } else {
      newMinute = minute.toString();
    }
    return newHour.toString() + ':' + newMinute;
  }

  //validator
  final validateAgenda = StreamTransformer<String, String>.fromHandlers(
      handleData: (getAgenda, sink) {
    if (getAgenda.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getAgenda);
    }
  });
  final validateLocation = StreamTransformer<String, String>.fromHandlers(
      handleData: (getLocation, sink) {
    if (getLocation.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getLocation);
    }
  });

  void dispose() {
    _agenda.close();
    _dateEnd.close();
    _dateStart.close();
    _location.close();
    _timeStart.close();
    _timeEnd.close();
    _agendaCategory.close();
    _divisionTypeList.close();
    _divisionValueList.close();
  }
}
