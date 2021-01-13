import 'package:shared_preferences/shared_preferences.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  addPresensiWithAgenda(String scanResult, String idAgenda) async {
    final prefs = await SharedPreferences.getInstance();
    String nim = scanResult;
    dynamic data = {'pengurus_nim': nim, 'agenda_id': idAgenda};
    print(data);
    return await _repository.addPresensi(data);
  }

  deleteAgenda(String id_agenda) async {
    return await _repository.deleteAgenda(id_agenda);
  }
}
