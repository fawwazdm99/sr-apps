import 'package:rxdart/subjects.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  final _listAgenda = BehaviorSubject<dynamic>();

  //add
  Function(dynamic) get updateListAgenda => _listAgenda.sink.add;
  //stream
  Stream<dynamic> get getListAgenda => _listAgenda.stream;
  //function
  Future getAllAgenda() async {
    dynamic res = await _repository.getAllAgenda();
    updateListAgenda(res);
    return res;
  }

  void dispose() {
    _listAgenda.close();
  }
}
