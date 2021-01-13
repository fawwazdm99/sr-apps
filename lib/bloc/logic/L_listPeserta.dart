import 'package:rxdart/rxdart.dart';

import '../repository.dart';

class Bloc {
  final _repository = Repository();
  final _listPeserta = BehaviorSubject<dynamic>();

  //stream
  Stream<dynamic> get getListPeserta => _listPeserta.stream;

  //add
  Function(dynamic) get updateListPeserta => _listPeserta.sink.add;
  //function
  Future getAllPeserta(id) async {
    dynamic res = await _repository.getAllPeserta(id);
    updateListPeserta(res);
    return res;
  }

  Future deletePesertaPengurus(nim, idAgenda) async {
    dynamic data = {'nim': nim, 'agenda_id': idAgenda};
    dynamic res = await _repository.deletePesertaPengurus(data);
    return res;
  }

  Future deletePesertaGuest(id, idAgenda) async {
    dynamic data = {'guest_id': id, 'agenda_id': idAgenda};
    dynamic res = await _repository.deletePesertaGuest(data);
    return res;
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
    String newMinute = minute.toString();
    String newHour = hour.toString();
    String newDay = day.toString();
    if (minute < 10) {
      newMinute = '0' + minute.toString();
    }
    if (hour < 10) {
      newHour = '0' + hour.toString();
    }
    return newDay + ' ' + newMonth + ', ' + newHour + ':' + newMinute;
  }

  void dispose() {
    _listPeserta.close();
  }
}
