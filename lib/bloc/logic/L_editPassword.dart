import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _oldPassword = BehaviorSubject<String>();
  static final _newPassword = BehaviorSubject<String>();
  final _newConfirmationPassword = BehaviorSubject<String>();

  //stream
  Stream<String> get getOldPassword =>
      _oldPassword.transform(validateOldPassword);
  Stream<String> get getNewPassword =>
      _newPassword.transform(validateNewPassword);
  Stream<String> get getNewConfirmationPassword =>
      _newConfirmationPassword.transform(validateNewConfirmationPassword);
  Stream<bool> get validateForm => CombineLatestStream(
      [getOldPassword, getNewPassword, getNewConfirmationPassword],
      ([getOldPassword, getNewPassword, getNewConfirmationPassword]) => true);

  //add
  Function(String) get updateOldPassword => _oldPassword.sink.add;
  Function(String) get updateNewPassword => _newPassword.sink.add;
  Function(String) get updateNewConfirmationPassword =>
      _newConfirmationPassword.sink.add;

  //validator
  final validateOldPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (getOldPassword, sink) {
    if (getOldPassword.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getOldPassword);
    }
  });
  final validateNewPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (getNewPassword, sink) {
    if (getNewPassword.isEmpty) {
      sink.addError('required');
    } else {
      sink.add(getNewPassword);
    }
  });
  final validateNewConfirmationPassword =
      StreamTransformer<String, String>.fromHandlers(
          handleData: (getNewConfirmationPassword, sink) {
    if (getNewConfirmationPassword != getNewPasswordVal()) {
      sink.addError('Password must be the same');
    } else {
      sink.add(getNewConfirmationPassword);
    }
  });
  //function
  static getNewPasswordVal() {
    return _newPassword.value;
  }

  Future updatePassword() async {
    final prefs = await SharedPreferences.getInstance();
    String oldPassword = _oldPassword.value;
    String newPassword = _newPassword.value;
    String newConfirmationPassword = _newConfirmationPassword.value;
    String nim = prefs.getString('nim');
    dynamic data = {
      'password': oldPassword,
      'new_password': newPassword,
      'confirmation_password': newConfirmationPassword,
      'nim': nim
    };
    dynamic res = _repository.updatePassword(data);
    return res;
  }

  void dispose() {
    _oldPassword.close();
    _newPassword.close();
    _newConfirmationPassword.close();
  }
}
