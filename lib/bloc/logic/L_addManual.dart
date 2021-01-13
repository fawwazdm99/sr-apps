import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _nim = BehaviorSubject<String>();

  //stream
  Stream<String> get getNim => _nim.stream.transform(validateNim);
  Stream<bool> get validateForm =>
      CombineLatestStream([getNim], ([getNim]) => true);

  //add
  Function(String) get updateNim => _nim.sink.add;
  //function
  Future addPresensi(idAgenda) async {
    String nim = _nim.value;
    dynamic data = {'pengurus_nim': nim, 'agenda_id': idAgenda};
    dynamic res = await _repository.addPresensi(data);
    return res;
  }

  dispose() {
    _nim.close();
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
}
