import 'package:sr_apps/bloc/apiProvider.dart';

class Repository {
  final apiProvider = ApiProvider();
  Future getAllDivision() async {
    return await apiProvider.getAllDivision();
  }

  Future getAllAgenda() async {
    return await apiProvider.getAllAgenda();
  }

  Future getAllAgendaCategory() async {
    return await apiProvider.getAllAgendaCategory();
  }

  Future createAgenda(data) async {
    return await apiProvider.createAgenda(data);
  }

  Future signup(data) async {
    return await apiProvider.signup(data);
  }

  Future login(data) async {
    return await apiProvider.login(data);
  }

  Future addPresensi(data) async {
    return await apiProvider.addPresensi(data);
  }

  Future getAllPeserta(id) async {
    return await apiProvider.getAllPeserta(id);
  }

  Future addGuest(data) async {
    return await apiProvider.addGuest(data);
  }

  Future addGuestPresensi(data) async {
    return await apiProvider.addGuestPresensi(data);
  }

  Future getPresensiReport(nim) async {
    return await apiProvider.getPresensiReport(nim);
  }

  Future getRecentAgenda() async {
    return await apiProvider.getRecentAgenda();
  }

  Future updateProfile(data) async {
    return await apiProvider.updateProfile(data);
  }

  Future deleteAgenda(id_agenda) async {
    return await apiProvider.deleteAgenda(id_agenda);
  }

  Future updateAgenda(data) async {
    return await apiProvider.updateAgenda(data);
  }

  Future getBidangName(id) async {
    return await apiProvider.getBidangName(id);
  }

  Future updatePassword(data) async {
    return await apiProvider.updatePassword(data);
  }

  Future deletePesertaPengurus(data) async {
    return await apiProvider.deletePesertaPengurus(data);
  }

  Future deletePesertaGuest(data) async {
    return await apiProvider.deletePesertaGuest(data);
  }
}
