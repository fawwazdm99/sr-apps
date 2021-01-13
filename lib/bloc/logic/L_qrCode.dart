import 'package:shared_preferences/shared_preferences.dart';
import 'package:sr_apps/bloc/repository.dart';

class Bloc {
  final _repository = Repository();
  Future getUserCode() async {
    final prefs = await SharedPreferences.getInstance();
    String nim = await prefs.getString('nim');
    dynamic data = {'nim': nim};
    return data;
  }

  addPresensi(String scanResult) async {
    final prefs = await SharedPreferences.getInstance();
    String nim = prefs.getString('nim');
    dynamic data = {'pengurus_nim': nim, 'agenda_id': scanResult};
    print(data);
    return await _repository.addPresensi(data);
  }
}
