import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/bloc/logic/L_listPeserta.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class ListPesertaView extends StatefulWidget {
  final dynamic data;
  ListPesertaView({Key key, this.data}) : super(key: key);

  @override
  _ListPesertaViewState createState() => _ListPesertaViewState();
}

class _ListPesertaViewState extends State<ListPesertaView> {
  static dynamic bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Peserta'),
        elevation: 0,
      ),
      backgroundColor: Colors.lime[900],
      body: RefreshIndicator(
          onRefresh: () {
            return bloc.getAllPeserta(widget.data['id']);
          },
          child: ListView(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height / 1),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                    ),
                    color: Colors.white,
                  ),
                  child: StreamBuilder(
                    stream: bloc.getListPeserta,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data);
                        return ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return PesertaList(
                                pengurus: snapshot.data['data']['presensi']
                                    ['pengurus'],
                                guest: snapshot.data['data']['presensi']
                                    ['guest'],
                                id: snapshot.data['data']['agenda'][0]['id'],
                                bloc: bloc,
                              );
                            });
                      } else {
                        bloc.getAllPeserta(widget.data['id']);
                        return AlertDialog(
                          elevation: 0,
                          content: Container(
                              width: 50,
                              height: 50,
                              child: SpinKitDualRing(
                                color: Colors.lime[900],
                              )),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class PesertaList extends StatelessWidget {
  final dynamic bloc;
  final dynamic pengurus;
  final dynamic guest;
  final String id;
  const PesertaList({Key key, this.pengurus, this.guest, this.id, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Builder(builder: (context) {
          if (pengurus.length == 0) {
            return Column(
              children: <Widget>[
                Text(
                  'Pengurus',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tidak ada pengurus yang terdaftar'),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Text(
                  'Pengurus',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: pengurus.length,
                    itemBuilder: (context, index) {
                      return Peserta(
                        name: pengurus[index]['name'].toString(),
                        nim: pengurus[index]['nim'],
                        time: bloc.getDateConvert(
                            DateTime.parse(pengurus[index]['kehadiran'])),
                        id: id,
                        bloc: bloc,
                      );
                    }),
                Padding(padding: EdgeInsets.all(10)),
              ],
            );
          }
        }),
        Builder(builder: (context) {
          if (guest.length == 0) {
            return Column(
              children: <Widget>[
                Text(
                  'Tamu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Tidak ada Tamu yang terdaftar'),
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Text(
                  'Tamu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: guest.length,
                    itemBuilder: (context, index) {
                      return Peserta(
                        name: guest[index]['name'].toString(),
                        nim: guest[index]['faculty'].toString() +
                            ' / ' +
                            guest[index]['study_program'].toString(),
                        time: bloc.getDateConvert(
                            DateTime.parse(guest[index]['kehadiran'])),
                        id: id,
                        idGuest: guest[index]['id'],
                        bloc: bloc,
                      );
                    }),
              ],
            );
          }
        })
      ],
    );
  }
}

class Peserta extends StatefulWidget {
  final String name;
  final String nim;
  final String time;
  final String id;
  final String type;
  final String idGuest;
  final dynamic bloc;
  const Peserta({
    Key key,
    this.name,
    this.nim,
    this.time,
    this.id,
    this.type,
    this.idGuest,
    this.bloc,
  }) : super(key: key);

  @override
  _PesertaState createState() => _PesertaState();
}

class _PesertaState extends State<Peserta> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.nim),
                  ],
                )),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        widget.time,
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showDeletePesertaDialog(context);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                  ],
                ))
          ],
        ));
  }

  _showDeletePesertaDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus Presensi?'),
            content: widget.idGuest == null
                ? Text('Kamu akan menghapus presensi dengan nim  ' + widget.nim)
                : Text('Kamu akan menghapus presensi tamu dengan nama ' +
                    widget.name),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                elevation: 0,
                color: Colors.white,
                child: Text(
                  'cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  // Navigator.of(context).pop();
                  await Future.delayed(Duration(milliseconds: 100));
                  loaderDialog(
                      context,
                      SpinKitThreeBounce(color: Colors.lime[900]),
                      'wait a minute...');
                  dynamic data;
                  if (widget.idGuest == null) {
                    data = await widget.bloc
                        .deletePesertaPengurus(widget.nim, widget.id);
                  } else {
                    data = await widget.bloc
                        .deletePesertaGuest(widget.idGuest, widget.id);
                  }
                  if (data['error']) {
                    Navigator.of(context).pop();
                    await Future.delayed(Duration(milliseconds: 100));
                    errorDialog(context, data['message']);
                  } else {
                    Navigator.of(context).pop();
                    await Future.delayed(Duration(milliseconds: 100));
                    Navigator.of(context).pop();
                    await Future.delayed(Duration(milliseconds: 100));
                    await widget.bloc.getAllPeserta(widget.id);
                  }
                },
                color: Colors.lime[900],
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        });
  }
}
