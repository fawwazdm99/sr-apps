import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/bloc/logic/L_detailAgenda.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class DetailAgendaView extends StatefulWidget {
  final dynamic data;
  DetailAgendaView({Key key, this.data}) : super(key: key);

  @override
  _DetailAgendaViewState createState() => _DetailAgendaViewState();
}

class _DetailAgendaViewState extends State<DetailAgendaView> {
  final bloc = Bloc();
  var isScanning = false;
  var scanStatus = false;
  var scanResult;

  startScan() async {
    dynamic cameraScanResult = await BarcodeScanner.scan();

    dynamic res =
        await bloc.addPresensiWithAgenda(cameraScanResult, widget.data['id']);
    print(res);
    setState(() {
      scanResult = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Agenda'),
          elevation: 0,
        ),
        backgroundColor: Colors.lime[900],
        body: Builder(builder: (context) {
          return ListView(
            children: <Widget>[
              ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height / 1.1),
                  child: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(50))),
                      child: Column(
                        children: <Widget>[
                          AgendaCard(
                            title: widget.data['title'],
                            date: widget.data['date'],
                            month: widget.data['month'],
                            location: widget.data['location'],
                            time: widget.data['time'],
                            id: widget.data['id'],
                            status: widget.data['status'],
                            creator: widget.data['creator'],
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                              child: QrImage(
                                data: widget.data['id'],
                                version: QrVersions.auto,
                                size: MediaQuery.of(context).size.width / 1.5,
                                // embeddedImage:
                                //     AssetImage('assets/img/wirda.png'),
                                // embeddedImageStyle: QrEmbeddedImageStyle(
                                //   size: Size(60, 60),
                                // ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                elevation: 2,
                                child: InkResponse(
                                  radius: 200,
                                  containedInkWell: false,
                                  onTap: () async {
                                    Navigator.of(context).pushNamed(
                                        AddManualViewRoute,
                                        arguments: {'id': widget.data['id']});
                                  },
                                  child: Container(
                                      width: 80,
                                      height: 80,
                                      padding: EdgeInsets.all(15),
                                      child: Icon(
                                        Icons.person_add,
                                        size: 40,
                                        color: Colors.lime[900],
                                      )),
                                ),
                              ),
                              Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                elevation: 2,
                                child: InkResponse(
                                  radius: 200,
                                  containedInkWell: false,
                                  onTap: () async {
                                    print(isScanning);
                                    setState(() {
                                      isScanning = true;
                                    });
                                    await startScan();
                                    if (scanResult['error']) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Scan failed, ' +
                                            scanResult.toString()),
                                        duration: Duration(seconds: 2),
                                      ));
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Scan Success, ' +
                                            scanResult['message'].toString() +
                                            ' untuk NIM: ' +
                                            scanResult['data']['pengurus_nim']),
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                    setState(() {
                                      isScanning = false;
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    padding: EdgeInsets.all(15),
                                    child: Image(
                                        image:
                                            AssetImage('assets/img/scan.png')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        AddGuestViewRoute,
                                        arguments: {
                                          'agenda_id': widget.data['id']
                                        });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.white,
                                  ),
                                  color: Colors.lime[900],
                                  label: Text(
                                    'Tambah Tamu',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              RaisedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ListPesertaViewRoute,
                                        arguments: {'id': widget.data['id']});
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.account_circle,
                                      color: Colors.white),
                                  color: Colors.lime[900],
                                  label: Text(
                                    'Daftar Peserta',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              RaisedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        EditAgendaViewRoute,
                                        arguments: {
                                          'id': widget.data['id'],
                                          'title': widget.data['title'],
                                          'category_id':
                                              widget.data['category_id'],
                                          'creator': widget.data['creator'],
                                          'date_start': widget.data['start_at'],
                                          'date_end': widget.data['end_at'],
                                          'time_start': TimeOfDay.fromDateTime(
                                              widget.data['start_at']),
                                          'time_end': TimeOfDay.fromDateTime(
                                              widget.data['end_at']),
                                          'location': widget.data['location'],
                                          'pengurus_nim':
                                              widget.data['pengurus_nim']
                                        });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                  color: Colors.lime[900],
                                  label: Text(
                                    'Edit Agenda',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              RaisedButton.icon(
                                  onPressed: () async {
                                    _showDeleteAgendaDialog(context);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  color: Colors.white,
                                  label: Text(
                                    'Hapus Agenda',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            ],
                          )
                        ],
                      )))
            ],
          );
        }));
  }

  _showDeleteAgendaDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Hapus Agenda?'),
            content: Text('Kamu akan menghapus seluruh data agenda ' +
                widget.data['title']),
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
                  dynamic data = await bloc.deleteAgenda(widget.data['id']);
                  if (data['error']) {
                    Navigator.of(context).pop();
                    await Future.delayed(Duration(milliseconds: 100));
                    errorDialog(context, data['message']);
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeViewRoute, (Route<dynamic> route) => false);
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

class AgendaCard extends StatelessWidget {
  final String date;
  final String month;
  final String title;
  final String time;
  final String location;
  final String id;
  final String status;
  final String creator;
  const AgendaCard({
    Key key,
    this.date,
    this.month,
    this.title,
    this.time,
    this.location,
    this.id,
    this.status,
    this.creator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: Container(
          alignment: Alignment.center,
          // padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.lime[900],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        date,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      Text(
                        month,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.fromLTRB(10, 7, 7, 7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                            color: Colors.lime[900],
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.watch_later,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          Text(time,
                              style: TextStyle(
                                color: Colors.lime[900],
                              ))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding: EdgeInsets.all(3),
                          ),
                          Expanded(
                            child: Text(location,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  color: Colors.lime[900],
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Container(
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            status,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            creator,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
