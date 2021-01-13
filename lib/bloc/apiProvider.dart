import 'dart:async';

import 'package:dio/dio.dart';
import 'package:sr_apps/bloc/template.dart';

class ApiProvider {
  Dio dio = new Dio();

  final String _baseUrl = baseUrl;

  Future login(data) async {
    FormData formData =
        FormData.fromMap({'nim': data['nim'], 'password': data['password']});
    final response = await dio.post("$_baseUrl/login/pengurus", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getAllDivision() async {
    final response = await dio.get("$_baseUrl/bidang/get");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getAllAgenda() async {
    final response = await dio.get("$_baseUrl/agenda/get");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getAllAgendaCategory() async {
    final response = await dio.get("$_baseUrl/agenda_category/get");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future createAgenda(data) async {
    FormData formData = FormData.fromMap({
      'pengurus_nim': data['pengurus_nim'],
      'agenda_category': data['agenda_category'],
      'title': data['title'],
      'location': data['location'],
      'mulai': data['start_at'],
      'selesai': data['end_at']
    });
    final response = await dio.post("$_baseUrl/agenda/create", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future signup(data) async {
    FormData formData = FormData.fromMap({
      'nim': data['nim'],
      'password': data['password'],
      'bidang_id': data['bidang_id'],
      'name': data['name'],
      'jenis_kelamin': data['jenis_kelamin'],
      'birthday': data['birthday'],
      'faculty': data['faculty'],
      'study_program': data['study_program'],
      'role': data['role'],
      // 'picture': data['picture']
    });
    final response =
        await dio.post("$_baseUrl/pengurus/create", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future addPresensi(data) async {
    FormData formData = FormData.fromMap(
        {'pengurus_nim': data['pengurus_nim'], 'agenda_id': data['agenda_id']});
    final response =
        await dio.post("$_baseUrl/presensi_pengurus/create", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getAllPeserta(id) async {
    final response = await dio.get("$_baseUrl/presensi_report/get/$id/agenda");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getPresensiReport(nim) async {
    final response = await dio.get("$_baseUrl/presensi_report/get/$nim/nim");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getRecentAgenda() async {
    final response = await dio.get("$_baseUrl/agenda/recent");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future addGuest(data) async {
    FormData formData = FormData.fromMap({
      'name': data['name'],
      'faculty': data['faculty'],
      'study_program': data['study_program']
    });
    final response = await dio.post("$_baseUrl/guest/create", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future addGuestPresensi(data) async {
    FormData formData = FormData.fromMap({
      'guest_id': data['guest_id'],
      'agenda_id': data['agenda_id'],
    });
    final response =
        await dio.post("$_baseUrl/presensi_guest/create", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future updateProfile(data) async {
    String fileName;
    FormData formData;

    if (data['picture'] != '') {
      print('masuk string kosong');
      fileName = data['picture'].toString().split('/').last;
      formData = new FormData.fromMap({
        'nim': data['nim'],
        'bidang_id': data['bidang_id'],
        'name': data['name'],
        'birthday': data['birthday'],
        'faculty': data['faculty'],
        'study_program': data['study_program'],
        'jenis_kelamin': data['jenis_kelamin'],
        'picture':
            await MultipartFile.fromFile(data['picture'], filename: fileName)
      });
    } else {
      formData = new FormData.fromMap({
        'nim': data['nim'],
        'bidang_id': data['bidang_id'],
        'name': data['name'],
        'birthday': data['birthday'],
        'faculty': data['faculty'],
        'study_program': data['study_program'],
        'jenis_kelamin': data['jenis_kelamin'],
      });
    }

    final response =
        await dio.post("$_baseUrl/pengurus/update", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future deleteAgenda(id_agenda) async {
    FormData formData = FormData.fromMap({'id': id_agenda});
    final response = await dio.post("$_baseUrl/agenda/delete", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future updateAgenda(data) async {
    FormData formData = FormData.fromMap({
      'id': data['id'],
      'pengurus_nim': data['pengurus_nim'],
      'agenda_category': data['agenda_category'],
      'title': data['title'],
      'location': data['location'],
      'start_at': data['start_at'],
      'end_at': data['end_at']
    });
    final response = await dio.post("$_baseUrl/agenda/update", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future getBidangName(id) async {
    final response = await dio.get("$_baseUrl/bidang/get/$id");

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future updatePassword(data) async {
    FormData formData = FormData.fromMap({
      'password': data['password'],
      'new_password': data['new_password'],
      'confirmation_password': data['confirmation_password'],
      'nim': data['nim']
    });
    final response =
        await dio.post("$_baseUrl/pengurus/update_password", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future deletePesertaPengurus(data) async {
    FormData formData =
        FormData.fromMap({'nim': data['nim'], 'agenda_id': data['agenda_id']});
    final response =
        await dio.post("$_baseUrl/presensi_pengurus/delete", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }

  Future deletePesertaGuest(data) async {
    FormData formData = FormData.fromMap(
        {'guest_id': data['guest_id'], 'agenda_id': data['agenda_id']});
    final response =
        await dio.post("$_baseUrl/presensi_guest/delete", data: formData);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Server error');
    }
  }
}
