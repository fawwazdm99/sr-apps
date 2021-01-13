import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _nim = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  //stream
  Stream<String> get getNim => _nim.stream.transform(validateNim);
  Stream<String> get getPassword =>
      _password.stream.transform(validatePassword);
  Stream<bool> get validateForm => CombineLatestStream(
      [getNim, getPassword], ([getNim, getPassword]) => true);

  //add
  Function(String) get updateNim => _nim.sink.add;
  Function(String) get updatePassword => _password.sink.add;
  //function
  getNimVal() {
    return _nim.value;
  }

  getPasswordVal() {
    return _password.value;
  }

  login() async {
    String nim = _nim.value;
    String password = _password.value;
    dynamic data = {'nim': nim, 'password': password};
    dynamic res = await _repository.login(data);
    if (!res['error']) {
      final prefs = await SharedPreferences.getInstance();
      dynamic userData = res['data'];
      await prefs.setString('nim', userData['nim']);
      await prefs.setString('bidang_id', userData['bidang_id']);
      await prefs.setString('name', userData['name']);
      await prefs.setString('birthday_date', userData['birthday_date']);
      await prefs.setString('faculty', userData['faculty']);
      await prefs.setString('study_program', userData['study_program']);
      await prefs.setString('role', userData['role']);
      await prefs.setString('bidang', userData['bidang']);
      await prefs.setString('picture', userData['picture']);
      await prefs.setString('jenis_kelamin', userData['jenis_kelamin']);
    }
    return res;
  }

  //validator
  final validateNim = StreamTransformer<String, String>.fromHandlers(
      handleData: (getNim, sink) {
    if (getNim.isEmpty) {
      sink.addError('Required');
    } else {
      sink.add(getNim);
    }
  });
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (getPassword, sink) {
    if (getPassword.isEmpty) {
      sink.addError('Required');
    } else {
      sink.add(getPassword);
    }
  });

  void dispose() {
    _nim.close();
    _password.close();
  }
}
