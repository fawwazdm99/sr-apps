import 'package:shared_preferences/shared_preferences.dart';

class Bloc {
  Future getUserPref() async {
    final prefs = await SharedPreferences.getInstance();
    String nim = prefs.getString('nim');
    String name = prefs.getString('name');
    String study_program = prefs.getString('study_program');
    String faculty = prefs.getString('faculty');
    String bidang = prefs.getString('bidang');
    String jenis_kelamin = prefs.getString('jenis_kelamin');
    String picture = prefs.getString('picture');
    dynamic data = {
      'nim': nim,
      'name': name,
      'study_program': study_program,
      'faculty': faculty,
      'bidang': bidang,
      'jenis_kelamin': jenis_kelamin,
      'picture': picture
    };
    return data;
  }

  Future getBidang() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('bidang_id');
  }

  logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
