import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sr_apps/bloc/template.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/bloc/logic/L_home.dart';
import 'package:sr_apps/view/widget/customDialog.dart';
import 'package:sr_apps/view/widget/errorDialog.dart';
import 'package:sr_apps/view/widget/loaderDialog.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static dynamic bloc = Bloc();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  DateTime selectedDateStart = bloc.getDateStartVal();
  TimeOfDay selectedTimeStart = bloc.getTimeStartVal();
  Future<Null> _selectDateStart(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: bloc.getDateStartVal(),
      firstDate: DateTime(1975),
      lastDate: DateTime(2050),
      // selectableDayPredicate: (DateTime val) =>
      //     val.weekday == 6 || val.weekday == 7 ? true : false,
    );

    if (picked != null)
      setState(() {
        bloc.updateDateStart(picked);
        bloc.updateDateEnd(picked);
        selectedDateStart = picked;
        _selectTimeStart(context);
        // selectedDateStart = picked;
      });
  }

  Future<Null> _selectTimeStart(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: bloc.getTimeStartVal());
    if (picked != null)
      setState(() {
        bloc.updateTimeStart(picked);
        int hour = picked.hour + 1;
        int minute = picked.minute;
        TimeOfDay newTimeEnd = TimeOfDay(hour: hour, minute: minute);
        bloc.updateTimeEnd(newTimeEnd);

        selectedTimeStart = picked;
        selectedTimeEnd = newTimeEnd;

        // selectedDateStart = picked;
      });
  }

  DateTime selectedDateEnd = bloc.getDateEndVal();
  TimeOfDay selectedTimeEnd = bloc.getTimeEndVal();
  Future<Null> _selectDateEnd(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: bloc.getDateEndVal(),
      firstDate: DateTime(1975),
      lastDate: DateTime(2050),
      // selectableDayPredicate: (DateTime val) =>
      //     val.weekday == 6 || val.weekday == 7 ? true : false,
    );

    if (picked != null)
      setState(() {
        bloc.updateDateEnd(picked);
        selectedDateEnd = picked;
        _selectTimeEnd(context);
        // selectedDateStart = picked;
      });
  }

  Future<Null> _selectTimeEnd(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: bloc.getTimeEndVal());
    if (picked != null)
      setState(() {
        bloc.updateTimeEnd(picked);
        selectedTimeEnd = picked;

        // selectedDateStart = picked;
      });
  }

  List _divisionType;
  List _divisionValue;
  List<DropdownMenuItem<String>> _divisionItems;
  String _currentDivision;
  // @override
  // void initState() {
  //   _currentdivision = "Khatmil Qur'an";

  //   super.initState();
  // }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    int counter = 0;

    for (String division in _divisionType) {
      items.add(new DropdownMenuItem(
          value: _divisionValue[counter], child: new Text(division)));
      counter++;
    }

    return items;
  }

  void changedDropDownItem(String selectedType) {
    setState(() {
      _currentDivision = selectedType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return bloc.getAllHomeData();
        },
        child: Container(
            color: Colors.lime[100],
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                      margin: EdgeInsets.only(bottom: 70),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(ProfileViewRoute);
                                },
                                child: FutureBuilder(
                                    future: bloc.getPict(),
                                    builder: (context, snapshot) {
                                      return CircleAvatar(
                                        backgroundColor: Colors.white,
                                        maxRadius: 30,
                                        backgroundImage: snapshot.data == null
                                            ? AssetImage(
                                                'assets/img/logo-sr.png')
                                            : NetworkImage(snapshot.data),
                                      );
                                    }),
                              ),
                              Column(
                                children: <Widget>[
                                  FutureBuilder(
                                      future: bloc.getName(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Hai, ' + snapshot.data,
                                                  style: TextStyle(
                                                      color: Colors.lime[900],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18)),
                                              Text(
                                                'Bagaimana Kabarnya?',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              Text(
                                                  'Masih semangat pembinaan, dong!',
                                                  style:
                                                      TextStyle(fontSize: 12))
                                            ],
                                          );
                                        } else {
                                          return Text('');
                                        }
                                      })
                                ],
                              ),
                              InkResponse(
                                radius: 30,
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(QrCodeViewRoute);
                                },
                                child: Image(
                                  image: AssetImage('assets/img/qr-code.png'),
                                  alignment: Alignment.center,
                                  width: 30,
                                  fit: BoxFit.contain,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height / 1.2,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50))),
                        child: StreamBuilder(
                            stream: bloc.getHomeData,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                bloc.getAllHomeData();
                                return SpinKitDualRing(color: Colors.lime[900]);
                              } else {
                                return Column(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(20, 30, 0, 30),
                                      transform: Matrix4.translationValues(
                                          0, -100.0, 0.0),
                                      child: SizedBox(
                                          height: 150,
                                          child: Builder(builder: (context) {
                                            if (snapshot
                                                    .data['presensi']['data']
                                                    .length ==
                                                0) {
                                              return Text('');
                                            } else {
                                              return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: snapshot
                                                      .data['presensi']['data']
                                                      .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    dynamic data = snapshot
                                                            .data['presensi']
                                                        ['data'];

                                                    return ProgressCard(
                                                      category: data[index]
                                                          ['kategori'],
                                                      present: data[index]
                                                          ['kehadiran'],
                                                      percent: double.parse(
                                                          data[index]
                                                                  ['persentase']
                                                              .toString()),
                                                    );
                                                  });
                                            }
                                          })),
                                    ),
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0, -100.0, 0.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons
                                                                .calendar_today,
                                                            size: 30,
                                                            color: Colors
                                                                .lime[900],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                          ),
                                                          Text(
                                                            'Agenda',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .lime[900],
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: RichText(
                                                        text: TextSpan(
                                                            text: 'Lainnya',
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pushNamed(
                                                                            ListAgendaViewRoute);
                                                                  },
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.lime[
                                                                        900])),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Builder(builder: (context) {
                                                  if (snapshot
                                                          .data['agenda']
                                                              ['data']
                                                          .length ==
                                                      0) {
                                                    return Column(
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10)),
                                                        Text(
                                                            'Belum ada agenda di waktu dekat, Semangat kuliahnya!')
                                                      ],
                                                    );
                                                  } else {
                                                    return ListView.builder(
                                                        itemCount: snapshot
                                                            .data['agenda']
                                                                ['data']
                                                            .length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemBuilder:
                                                            (context, index) {
                                                          dynamic data =
                                                              snapshot.data[
                                                                      'agenda']
                                                                  ['data'];
                                                          return AgendaCard(
                                                            date: data[index][
                                                                    'waktu_mulai']
                                                                ['tahun'],
                                                            month: data[index][
                                                                    'waktu_mulai']
                                                                ['bulan'],
                                                            title: data[index]
                                                                ['title'],
                                                            location: data[
                                                                    index]
                                                                ['location'],
                                                            id: data[index]
                                                                ['id'],
                                                            creator: data[index]
                                                                ['creator'],
                                                            status: data[index]
                                                                ['status'],
                                                            time: data[index][
                                                                        'waktu_mulai']
                                                                    ['jam'] +
                                                                '-' +
                                                                data[index][
                                                                        'waktu_selesai']
                                                                    ['jam'],
                                                            start_at: DateTime
                                                                .parse(data[
                                                                        index][
                                                                    'start_at']),
                                                            end_at: DateTime
                                                                .parse(data[
                                                                        index]
                                                                    ['end_at']),
                                                            category_id: data[
                                                                    index][
                                                                'agenda_category_id'],
                                                            pengurus_nim: data[
                                                                    index][
                                                                'pengurus_nim'],
                                                          );
                                                        });
                                                  }
                                                }),
                                                Padding(
                                                  padding: EdgeInsets.all(10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 0, 10, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.star_border,
                                                        size: 30,
                                                        color: Colors.lime[900],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(5),
                                                      ),
                                                      Text(
                                                        'Kenali SR Lebih Dekat',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .lime[900],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 10, 0, 30),
                                            // transform: Matrix4.translationValues(0, -150.0, 0.0),
                                            child: SizedBox(
                                                height: 150,
                                                child: ListView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  children: <Widget>[
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/1%20SQ1.jpg',
                                                      title:
                                                          'SYARHIL QUR’AN (SQ)',
                                                      content:
                                                          'Jenis pembinaan yang mempelajari bagaimana menyampaikan isi dan kandungan Al-Qur’an dengan disertai pembacaan ayat Al-Quran, puitisasi terjemah dan uraian yang merupakan kesatuan yang serasi dengan tujuan meningkatkan pemahaman dan penghayatan terhadap isi kandungan Al-Qur’an sehingga terwujud suatu pengamalan nyata terhadap petunjuk dan bimbingan-Nya.',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/2%20KIA1.jpg',
                                                      title:
                                                          'KARYA ILMIAH AL-QUR’AN (KIA)',
                                                      content:
                                                          'Jenis pembinaan menulis karya tulis ilmia Al-Qur’an sesuai sistematika penulisan ilmiah dan merancang aplikasi berbasis kandungan Al-Qur’an dan Hadits yang kemudian dikaitkan dengan suatu fenomena yang terjadi dalam rangka memberikan kontribusi kepada masyarakat umum. KIA tebagi menjadi 2 cabang pembinaan yaitu Karya Tulis Ilmiah Al-Qur’an dan Desain Aplikasi Al-Qur’an.',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/3%20FQ1.jpg',
                                                      title:
                                                          'FAHMIL QUR’AN (FQ)',
                                                      content:
                                                          'Jenis pembinaan yang mengajarkan tentang pemahaman dan pendalaman Al-Qur’an dengan penekanan pada pengungkapan ilmu Al-Qur’an dan pemahaman kandungan ayat.',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/4%20KQ1.jpg',
                                                      title:
                                                          'KHATTIL QUR’AN (KQ)',
                                                      content:
                                                          'Jenis pembinaan menulis indah Al-Qur’an yang menekankan kebenaran dan keindahan tulisan menurut kaidah khat yang baku.',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/5%20HQ1.jpg',
                                                      title:
                                                          'HIFDZIL QUR’AN (HQ)',
                                                      content:
                                                          'Jenis pembinaan menghafal Al-Qur’an dengan bacaan murattal yang sesuai dengan ilmu baca (tajwid), seni (lagu dan suara), serta etika (adab) menggunakan qiraat Imam Ashim riwayat Hafsh serta Mushaf Bahriah (Al-Qur’an Pojok).',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/6%20TQ1.jpg',
                                                      title:
                                                          'TILAWATIL QUR’AN (TQ)',
                                                      content:
                                                          'Jenis pembinaan membaca Al-Qur’an dengan bacaan mujawwad (bacaan Al-Qur’an yang mengandung nilai baca (tajwid), seni (lagu dan irama), serta etika (adab)).',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/7%20NASYID1.jpg',
                                                      title: 'NASYID ACAPELLA',
                                                      content:
                                                          'Jenis pembinaan dalam bidang olah vokal yang dilakukan secara berkelompok dan dalam membawakan lagu tanpa diiringi alat musik serta diperindah dengan harmonika dan irama beatbox.',
                                                    ),
                                                    ArticleCard(
                                                      image: baseUrl +
                                                          '/uploads/8%20BANJARI1.jpg',
                                                      title:
                                                          'HADRAH AL-BANJARI',
                                                      content:
                                                          'Jenis pembinaan membaca sholawat dan pujian kepada Nabi Muhammad SAW dengan diiringi alat musik terbang (rebana) yang dipukul menggunakan tangan dengan pukulan yang variatif sehingga menghasilkan irama musik yang syahdu.',
                                                    ),
                                                  ],
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => buildShowModalBottomSheet(context),
        backgroundColor: Colors.lime[900],
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Wrap(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Divider(
                      height: 5,
                      thickness: 5,
                      indent: 150,
                      endIndent: 150,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // ListAgendaCategory(),
                    StreamBuilder(
                        stream: bloc.getdivisionTypeList,
                        initialData: [],
                        builder: (context, snapshot) {
                          if (snapshot.data.length == 0 || !snapshot.hasData) {
                            bloc.getAllAgendaCategory();
                            return Container(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.lime[900]),
                            ));
                          } else {
                            _divisionType = bloc.getDivisionTypeValue();
                            _divisionValue = bloc.getDivisionValueValue();
                            if (_currentDivision == null) {
                              _currentDivision = _divisionValue[0].toString();
                              bloc.updateAgendaCategory(_currentDivision);
                            }

                            return DropdownButtonFormField(
                              decoration: InputDecoration(
                                  labelText: 'Kategori Agenda',
                                  contentPadding: EdgeInsets.all(0),
                                  labelStyle:
                                      TextStyle(color: Colors.lime[900]),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.lime[900],
                                  ))),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              items: getDropDownMenuItems(),
                              value: _currentDivision,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.lime[900],
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  bloc.updateAgendaCategory(value);
                                  _currentDivision = value;
                                });
                              },
                            );
                          }
                        }),
                    Padding(padding: EdgeInsets.all(10)),
                    StreamBuilder(
                        stream: bloc.getAgenda,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateAgenda,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Nama Agenda',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.lime[900]),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime[900], width: 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime[900], width: 2))),
                          );
                        }),
                    Padding(padding: EdgeInsets.all(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Waktu Mulai',
                            style: TextStyle(color: Colors.lime[900])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.lime[900],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: bloc.getDateStart,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(bloc.getDateConvert(
                                                  snapshot.data));
                                            } else {
                                              return Text('');
                                            }
                                          }),
                                      StreamBuilder(
                                          stream: bloc.getTimeStart,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(bloc.getTimeConvert(
                                                  snapshot.data));
                                            } else {
                                              return Text('');
                                            }
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                _selectDateStart(context);
                              },
                              child: Text('Pilih',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.lime[900],
                            )
                          ],
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(5)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Waktu Selesai',
                          style: TextStyle(color: Colors.lime[900]),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.lime[900],
                                  ),
                                  Padding(padding: EdgeInsets.all(5)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      StreamBuilder(
                                          stream: bloc.getDateEnd,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(bloc.getDateConvert(
                                                  snapshot.data));
                                            } else {
                                              return Text('');
                                            }
                                          }),
                                      StreamBuilder(
                                          stream: bloc.getTimeEnd,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(bloc.getTimeConvert(
                                                  snapshot.data));
                                            } else {
                                              return Text('');
                                            }
                                          })
                                    ],
                                  )
                                ],
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                _selectDateEnd(context);
                              },
                              child: Text('Pilih',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.lime[900],
                            )
                          ],
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: bloc.getLocation,
                        builder: (context, snapshot) {
                          return TextFormField(
                            onChanged: bloc.updateLocation,
                            decoration: InputDecoration(
                                errorText: snapshot.error,
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: Colors.lime[900],
                                ),
                                contentPadding: EdgeInsets.all(0),
                                labelText: 'Tambah Lokasi',
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.lime[900]),
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime[900], width: 1)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.lime[900], width: 2))),
                          );
                        }),
                    Padding(padding: EdgeInsets.all(10)),

                    Padding(padding: EdgeInsets.all(10)),
                    StreamBuilder(
                        stream: bloc.validateForm,
                        builder: (context, snapshot) {
                          return RaisedButton.icon(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () async {
                              if (snapshot.hasData) {
                                loaderDialog(
                                    context,
                                    SpinKitThreeBounce(color: Colors.lime[900]),
                                    'on working...');
                                dynamic response = await bloc.createAgenda();
                                if (response['error']) {
                                  Navigator.of(context).pop();
                                  errorDialog(context, response['message']);
                                } else {
                                  Navigator.of(context).pop();
                                  await Future.delayed(
                                      Duration(milliseconds: 100));
                                  customDialog(
                                      context,
                                      Icon(
                                        Icons.check,
                                        color: Colors.lime[900],
                                        size: 36,
                                      ),
                                      'Agenda Berhasil ditambahkan');
                                }
                              } else {
                                errorDialog(
                                    context, 'Make sure you complete the form');
                              }
                            },
                            icon: Icon(Icons.add, color: Colors.white),
                            color: Colors.lime[900],
                            label: Text(
                              'Tambah',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ArticleCard extends StatelessWidget {
  final image;
  final title;
  final content;
  const ArticleCard({
    Key key,
    this.image,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        dynamic data = {'title': title, 'image': image, 'content': content};
        Navigator.of(context)
            .pushNamed(DetailArticleViewRoute, arguments: data);
      },
      child: Container(
        width: 255,
        margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, offset: Offset(3, 3), blurRadius: 3)
            ],
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
            color: Colors.lime[900],
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerLeft,
                width: 275,
                padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Colors.lime[900].withOpacity(0.9)),
                child: Text(title,
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ),
      ),
    );
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
  final DateTime start_at;
  final DateTime end_at;
  final String category_id;
  final String pengurus_nim;
  const AgendaCard(
      {Key key,
      this.date,
      this.month,
      this.title,
      this.time,
      this.location,
      this.id,
      this.status,
      this.creator,
      this.start_at,
      this.end_at,
      this.category_id,
      this.pengurus_nim})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: InkWell(
          onTap: () {
            dynamic args = {
              'date': date,
              'month': month,
              'title': title,
              'time': time,
              'location': location,
              'id': id,
              'status': status,
              'creator': creator,
              'start_at': start_at,
              'end_at': end_at,
              'category_id': category_id,
              'pengurus_nim': pengurus_nim
            };
            Navigator.of(context)
                .pushNamed(DetailAgendaViewRoute, arguments: args);
          },
          child: Container(
            alignment: Alignment.center,
            // padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.lime[800],
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 90,
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
                                  color: Colors.white,
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
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.all(3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              status,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              creator,
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  static final bloc = Bloc();
  final String category;
  final String present;
  final double percent;
  const ProgressCard({
    Key key,
    this.category,
    this.present,
    this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topCenter,
            height: 125,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.lime[700],
            ),
            child: Text(
              category,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 95,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.lime[900],
            ),
            child: CircularPercentIndicator(
              radius: 70,
              backgroundColor: Colors.lime[800].withOpacity(0.5),
              progressColor: Colors.white,
              percent: percent,
              center: Text(present,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// class ListAgendaCategory extends StatefulWidget {
//   ListAgendaCategory({Key key}) : super(key: key);

//   @override
//   _ListAgendaCategoryState createState() => _ListAgendaCategoryState();
// }

// class _ListAgendaCategoryState extends State<ListAgendaCategory> {
//   static final bloc = Bloc();
//   List _divisionType;
//   List _divisionValue;
//   List<DropdownMenuItem<String>> _divisionItems;
//   String _currentDivision;
//   // @override
//   // void initState() {
//   //   _currentdivision = "Khatmil Qur'an";

//   //   super.initState();
//   // }

//   List<DropdownMenuItem<String>> getDropDownMenuItems() {
//     List<DropdownMenuItem<String>> items = new List();
//     int counter = 0;

//     for (String division in _divisionType) {
//       items.add(new DropdownMenuItem(
//           value: _divisionValue[counter], child: new Text(division)));
//       counter++;
//     }

//     return items;
//   }

//   void changedDropDownItem(String selectedType) {
//     setState(() {
//       _currentDivision = selectedType;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: bloc.getdivisionTypeList,
//         initialData: [],
//         builder: (context, snapshot) {
//           if (snapshot.data.length == 0 || !snapshot.hasData) {
//             bloc.getAllAgendaCategory();
//             return Container(
//                 child: CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.lime[900]),
//             ));
//           } else {
//             _divisionType = bloc.getDivisionTypeValue();
//             _divisionValue = bloc.getDivisionValueValue();
//             if (_currentDivision == null) {
//               _currentDivision = _divisionValue[0].toString();
//               // bloc.updateDivision(_currentdivision);
//             }

//             return DropdownButtonFormField(
//               decoration: InputDecoration(
//                   labelText: 'Kategori Agenda',
//                   contentPadding: EdgeInsets.all(0),
//                   labelStyle: TextStyle(color: Colors.lime[900]),
//                   enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                     color: Colors.lime[900],
//                   ))),
//               style: TextStyle(color: Colors.black, fontSize: 14),
//               items: getDropDownMenuItems(),
//               value: _currentDivision,
//               icon: Icon(
//                 Icons.keyboard_arrow_down,
//                 color: Colors.lime[900],
//               ),
//               onChanged: (String value) {
//                 setState(() {
//                   print(value);
//                   bloc.updateAgendaCategory(value);
//                   _currentDivision = value;
//                 });
//               },
//             );
//           }
//         });
//   }
// }
