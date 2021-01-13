import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:sr_apps/bloc/logic/L_qrCode.dart';

class QrCodeView extends StatefulWidget {
  QrCodeView({Key key}) : super(key: key);

  @override
  _QrCodeViewState createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  static final bloc = Bloc();
  var isScanning = false;
  var scanStatus = false;
  var scanResult;

  startScan() async {
    dynamic cameraScanResult = await BarcodeScanner.scan();

    dynamic res = await bloc.addPresensi(cameraScanResult);
    print(res);
    setState(() {
      scanResult = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'QR Code',
                        style: TextStyle(
                            color: Colors.lime[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      InkResponse(
                          radius: 30,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.close,
                            size: 32,
                          ))
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Tunjukkan ini untuk absen pada kegiatan \nUKM Seni Religi Universitas Brawijaya',
                          style: TextStyle(fontSize: 14),
                        ),
                        FutureBuilder(
                            future: bloc.getUserCode(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.fromLTRB(0, 20, 0, 20),
                                      child: QrImage(
                                        data: snapshot.data['nim'],
                                        version: QrVersions.auto,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                1.25,
                                        // embeddedImage:
                                        //     AssetImage('assets/img/wirda.png'),
                                        // embeddedImageStyle:
                                        //     QrEmbeddedImageStyle(
                                        //   size: Size(80, 80),
                                        // ),
                                      ),
                                    ),
                                    Text('Kode Saya: ' + snapshot.data['nim']),
                                  ],
                                );
                              } else {
                                return Text('');
                              }
                            }),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Center(
                            child: Column(
                          children: <Widget>[
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
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Scan failed, ' +
                                          scanResult.toString()),
                                      duration: Duration(seconds: 2),
                                    ));
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Scan Success, ' +
                                          scanResult['message'].toString()),
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
                                      image: AssetImage('assets/img/scan.png')),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text('Scan QR Code'),
                            Builder(builder: (context) {
                              if (isScanning) {
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      SpinKitThreeBounce(
                                        color: Colors.lime[900],
                                      ),
                                      Text('Wait a minute...')
                                    ],
                                  ),
                                );
                              } else {
                                return Text('');
                              }
                            })
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
