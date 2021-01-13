import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _name = BehaviorSubject<String>();
  final _faculty = BehaviorSubject<String>();
  final _studyProgram = BehaviorSubject<String>();

  //stream
  Stream<String> get getName => _name.stream.transform(validateName);
  Stream<String> get getFaculty => _faculty.stream.transform(validateFaculty);
  Stream<String> get getStudyProgram =>
      _studyProgram.stream.transform(validateStudyProgram);
  Stream<bool> get validateForm => CombineLatestStream(
      [getName, getFaculty, getStudyProgram],
      ([getName, getFaculty, getStudyProgram]) => true);

  //add
  Function(String) get updateName => _name.sink.add;
  Function(String) get updateFaculty => _faculty.sink.add;
  Function(String) get updateStudyProgram => _studyProgram.sink.add;

  //function
  addGuest(String agenda_id) async {
    String name = _name.value;
    String faculty = _faculty.value;
    String study_program = _studyProgram.value;
    dynamic data = {
      'name': name,
      'faculty': faculty,
      'study_program': study_program
    };
    dynamic res = await _repository.addGuest(data);
    print(res);
    String guest_id = res['data']['id'].toString();
    dynamic data2 = {'guest_id': guest_id, 'agenda_id': agenda_id};
    dynamic res2 = await _repository.addGuestPresensi(data2);
    return res2;
  }

  //valdiate
  final validateName = StreamTransformer<String, String>.fromHandlers(
      handleData: (getName, sink) {
    if (getName.isEmpty) {
      sink.addError("Required");
    } else {
      sink.add(getName);
    }
  });
  final validateFaculty = StreamTransformer<String, String>.fromHandlers(
      handleData: (getFaculty, sink) {
    if (getFaculty.isEmpty) {
      sink.addError("Fill with '-' if empty");
    } else {
      sink.add(getFaculty);
    }
  });
  final validateStudyProgram = StreamTransformer<String, String>.fromHandlers(
      handleData: (getStudyProgram, sink) {
    if (getStudyProgram.isEmpty) {
      sink.addError("Fill with '-' if empty");
    } else {
      sink.add(getStudyProgram);
    }
  });
  void dispose() {
    _name.close();
    _faculty.close();
    _studyProgram.close();
  }
}
