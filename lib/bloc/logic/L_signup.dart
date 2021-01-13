import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _nim = BehaviorSubject<String>();
  final _date = BehaviorSubject<DateTime>.seeded(DateTime.now());
  final _name = BehaviorSubject<String>();
  final _programme = BehaviorSubject<String>();
  final _faculty = BehaviorSubject<String>();
  final _division = BehaviorSubject<String>();
  static final _password = BehaviorSubject<String>();
  final _passwordConfirmation = BehaviorSubject<String>();
  final _divisionTypeList = BehaviorSubject<List>.seeded([]);
  final _divisionValueList = BehaviorSubject<List>.seeded([]);
  final _gender = BehaviorSubject<String>();
  bool _isDispose = false;

  //stream
  Stream<String> get getNim => _nim.stream.transform(validateNim);
  Stream<DateTime> get getDate => _date.stream;
  Stream<String> get getName => _name.stream.transform(validateName);
  Stream<String> get getProgramme =>
      _programme.stream.transform(validateProgramme);
  Stream<String> get getFaculty => _faculty.stream.transform(validateFaculty);
  Stream<String> get getDivision => _division.stream;
  Stream<String> get getPassword =>
      _password.stream.transform(validatePassword);
  Stream<String> get getPasswordConfirmation =>
      _passwordConfirmation.stream.transform(validatePasswordConfirmation);
  Stream<List> get getdivisionTypeList => _divisionTypeList.stream;
  Stream<String> get getGender => _gender.stream;
  Stream<bool> get validateForm => CombineLatestStream(
          [
            getNim,
            getName,
            getProgramme,
            getFaculty,
            getPassword,
            getPasswordConfirmation
          ],
          (
                  [getNim,
                  getName,
                  getProgramme,
                  getFaculty,
                  getPassword,
                  getPasswordConfirmation]) =>
              true);
  //add
  Function(String) get updateNim => _nim.sink.add;
  Function(DateTime) get updateDate => _date.sink.add;
  Function(String) get updateName => _name.sink.add;
  Function(String) get updateProgramme => _programme.sink.add;
  Function(String) get updateFaculty => _faculty.sink.add;
  Function(String) get updateDivision => _division.sink.add;
  Function(String) get updatePassword => _password.sink.add;
  Function(String) get updatePasswordConfirmation =>
      _passwordConfirmation.sink.add;
  Function(List) get updateDivisionTypeList => _divisionTypeList.sink.add;
  Function(List) get updateDivisionValueList => _divisionValueList.sink.add;
  Function(String) get updateGender => _gender.sink.add;

  //function
  getNimVal() {
    return _nim.value;
  }

  getDateVal() {
    return _date.value;
  }

  getNameVal() {
    return _name.value;
  }

  getProgrammeVal() {
    return _programme.value;
  }

  getFacultyVal() {
    return _faculty.value;
  }

  getDivisionVal() {
    return _division.value;
  }

  getPasswordVal() {
    return _password.value;
  }

  getPasswordConfirmationVal() {
    return _passwordConfirmation.value;
  }

  static getPasswordValue() {
    return _password.value;
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

  getDateConvert() {
    DateTime date = _date.value;
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

  signup() async {
    String nim = _nim.value;
    String password = _password.value;
    String bidang_id = _division.value;
    String name = _name.value;
    String jenis_kelamin = _gender.value;
    String birthday = dateConvertApi(_date.value);
    String faculty = _faculty.value;
    String study_program = _programme.value;
    String role = 'ANGGOTA';
    String picture = '';
    print(_division.value);
    dynamic data = {
      'nim': nim,
      'password': password,
      'bidang_id': bidang_id,
      'name': name,
      'jenis_kelamin': jenis_kelamin,
      'birthday': birthday,
      'faculty': faculty,
      'study_program': study_program,
      'role': role,
      'picture': picture,
    };
    dynamic res = await _repository.signup(data);
    return res;
  }

  //validator
  final validateNim = StreamTransformer<String, String>.fromHandlers(
      handleData: (getNim, sink) {
    if (getNim.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getNim);
    }
  });
  final validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (getName, sink) {
    if (getName.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getName);
    }
  });
  final validateProgramme = StreamTransformer<String, String>.fromHandlers(
      handleData: (getProgramme, sink) {
    if (getProgramme.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getProgramme);
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

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (getPassword, sink) {
    if (getPassword.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getPassword);
    }
  });
  final validatePasswordConfirmation =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (getPasswordConfirmation, sink) {
    if (getPasswordConfirmation != getPasswordValue()) {
      sink.addError('password must be the same');
    } else {
      sink.add(getPasswordConfirmation);
    }
  });
  void dispose() {
    _nim.close();
    _date.close();
    _name.close();
    _programme.close();
    _faculty.close();
    _divisionTypeList.close();
    _divisionValueList.close();
    _division.close();
    _password.close();
    _passwordConfirmation.close();
    _isDispose = true;
  }
}

// final bloc = Bloc();
