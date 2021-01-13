import 'dart:async';
import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _date = BehaviorSubject<DateTime>();
  final _nim = BehaviorSubject<String>();
  final _studyProgram = BehaviorSubject<String>();
  final _faculty = BehaviorSubject<String>();
  final _division = BehaviorSubject<String>();
  final _divisionTypeList = BehaviorSubject<List>.seeded([]);
  final _divisionValueList = BehaviorSubject<List>.seeded([]);
  final _isLoaded = BehaviorSubject<dynamic>();
  final _picture = BehaviorSubject<String>();
  final _gender = BehaviorSubject<String>();
  final _isUpdatePhoto = BehaviorSubject<bool>.seeded(false);
  bool _isDispose = false;

  //stream
  Stream<String> get getName => _name.stream.transform(validateName);
  Stream<DateTime> get getDate => _date.stream;
  Stream<String> get getNim => _nim.stream.transform(validateNim);
  Stream<String> get getStudyProgram =>
      _studyProgram.stream.transform(validateStudyProgram);
  Stream<String> get getFaculty => _faculty.stream.transform(validateFaculty);
  Stream<dynamic> get getIsLoaded => _isLoaded.stream;
  Stream<List> get getdivisionTypeList => _divisionTypeList.stream;
  Stream<String> get getGender => _gender.stream;
  Stream<bool> get validateForm => CombineLatestStream(
      [getName, getNim, getStudyProgram, getFaculty],
      ([getName, getNim, getStudyProgram, getFaculty]) => true);
  //add
  Function(String) get updateName => _name.sink.add;
  Function(DateTime) get updateDate => _date.sink.add;
  Function(String) get updateNim => _nim.sink.add;
  Function(String) get updateStudyProgram => _studyProgram.sink.add;
  Function(String) get updateFaculty => _faculty.sink.add;
  Function(String) get updateDivision => _division.sink.add;
  Function(List) get updateDivisionTypeList => _divisionTypeList.sink.add;
  Function(List) get updateDivisionValueList => _divisionValueList.sink.add;
  Function(dynamic) get updateIsLoaded => _isLoaded.sink.add;
  Function(String) get updatePicture => _picture.sink.add;
  Function(String) get updateGender => _gender.sink.add;
  Function(bool) get updateIsUpdatePhoto => _isUpdatePhoto.sink.add;

  //function

  getDivisionTypeValue() {
    return _divisionTypeList.value;
  }

  getDivisionValueValue() {
    return _divisionValueList.value;
  }

  getCurrentDivisionValue() {
    return _divisionTypeList.value[0].toString();
  }

  Future getAllDivision() async {
    if (_isDispose) {
      return;
    }
    dynamic res = await _repository.getAllDivision();
    List divisionType = [];
    List divisionValue = [];

    for (var item in res['data']) {
      divisionType.add(item['nama']);
      divisionValue.add(item['id']);
    }
    updateDivisionTypeList(divisionType);
    updateDivisionValueList(divisionValue);
    return res;
  }

  Future getPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    DateTime date = DateTime.parse(prefs.getString('birthday_date'));
    String nim = prefs.getString('nim');
    String studyProgram = prefs.getString('study_program');
    String faculty = prefs.getString('faculty');
    String bidang_id = prefs.getString('bidang_id');
    String picture = prefs.getString('picture');
    String jenis_kelamin = prefs.getString('jenis_kelamin');
    updateName(name);
    updateDate(date);
    updateNim(nim);
    updateStudyProgram(studyProgram);
    updateFaculty(faculty);
    updatePicture(picture);
    updateGender(jenis_kelamin);

    dynamic data = {
      'name': name,
      'date': date,
      'nim': nim,
      'studyProgram': studyProgram,
      'faculty': faculty,
      'bidang_id': bidang_id,
      'picture': picture,
      'jenis_kelamin': jenis_kelamin
    };
    updateIsLoaded(data);
  }

  Future updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String name = _name.value;
    String date = dateConvertApi(_date.value);
    String nim = _nim.value;
    String studyProgram = _studyProgram.value;
    String faculty = _faculty.value;
    String jenis_kelamin = _gender.value;
    String pictureBefore = prefs.getString('picture');

    String bidang_id = prefs.getString('bidang_id');
    String role = prefs.getString('role');

    String picture = _isUpdatePhoto.value ? _picture.value : '';

    dynamic data = {
      'nim': nim,
      'name': name,
      'bidang_id': bidang_id,
      'birthday': date,
      'faculty': faculty,
      'study_program': studyProgram,
      'picture': picture,
      'jenis_kelamin': jenis_kelamin
    };
    dynamic res = await _repository.updateProfile(data);

    prefs.setString('name', name);
    prefs.setString('bidang_id', bidang_id);
    prefs.setString('birthday', date);
    prefs.setString('faculty', faculty);
    prefs.setString('study_program', studyProgram);
    prefs.setString(
        'picture',
        res['data']['picture'] == null
            ? pictureBefore
            : res['data']['picture'].toString());
    prefs.setString('jenis_kelamin', jenis_kelamin);

    return res;
  }

  Future setNewPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String name = _name.value;
    String date = dateConvertApi(_date.value);

    String studyProgram = _studyProgram.value;
    String faculty = _faculty.value;

    String bidang_id = _division.value;
    dynamic res = await _repository.getBidangName(bidang_id);
    print(res);
    String bidang_name = res['data']['nama'];
    await prefs.setString('name', name);
    await prefs.setString('date', date);
    await prefs.setString('study_program', studyProgram);
    await prefs.setString('faculty', faculty);
    await prefs.setString('bidang_id', bidang_id);
    await prefs.setString('bidang', bidang_name);
  }

  getDateConvert(DateTime date) {
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

  dateConvertApi(DateTime date) {
    var day = date.day;
    var month = date.month;
    var year = date.year;
    var hour = date.hour;
    var minute = date.minute;
    String newMonth;
    String newDay;
    // if (month < 10) {
    //   newMonth = '0' + month.toString();
    // } else {
    //   newMonth = month.toString();
    // }
    // if (day < 10) {
    //   newDay = '0' + day.toString();
    // } else {
    //   newDay = day.toString();
    // }
    return year.toString() + '-' + month.toString() + '-' + day.toString();
  }

  //validator
  final validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (getName, sink) {
    if (getName.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getName);
    }
  });
  final validateNim = StreamTransformer<String, String>.fromHandlers(
      handleData: (getNim, sink) {
    if (getNim.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getNim);
    }
  });
  final validateStudyProgram = StreamTransformer<String, String>.fromHandlers(
      handleData: (getStudyProgram, sink) {
    if (getStudyProgram.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getStudyProgram);
    }
  });
  final validateFaculty = StreamTransformer<String, String>.fromHandlers(
      handleData: (getFaculty, sink) {
    if (getFaculty.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getFaculty);
    }
  });

  void dispose() {
    _name.close();
    _date.close();
    _nim.close();
    _studyProgram.close();
    _faculty.close();
    _divisionTypeList.close();
    _divisionValueList.close();
    _division.close();
    _picture.close();
    _isLoaded.close();
    _gender.close();
    _isDispose = true;
    _isUpdatePhoto.close();
  }
}
