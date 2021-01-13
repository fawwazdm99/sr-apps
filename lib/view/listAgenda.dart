import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/bloc/logic/L_listAgenda.dart';

class ListAgendaView extends StatefulWidget {
  ListAgendaView({Key key}) : super(key: key);

  @override
  _ListAgendaViewState createState() => _ListAgendaViewState();
}

class _ListAgendaViewState extends State<ListAgendaView> {
  static dynamic bloc;
  @override
  void initState() {
    // TODO: implement initState
    bloc = Bloc();
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime[900],
      appBar: AppBar(
        title: Text('Daftar Agenda'),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return bloc.getAllAgenda();
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
                      stream: bloc.getListAgenda,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (context, index) {
                                dynamic data = snapshot.data['data'];
                                return AgendaCard(
                                  title: data[index]['title'],
                                  date: data[index]['waktu_mulai']['tahun'],
                                  month: data[index]['waktu_mulai']['bulan'],
                                  location: data[index]['location'],
                                  time: data[index]['waktu_mulai']['jam'] +
                                      '-' +
                                      data[index]['waktu_selesai']['jam'],
                                  id: data[index]['id'],
                                  status: data[index]['status'],
                                  creator: data[index]['creator'],
                                  start_at:
                                      DateTime.parse(data[index]['start_at']),
                                  end_at: DateTime.parse(data[index]['end_at']),
                                  category_id: data[index]
                                      ['agenda_category_id'],
                                  pengurus_nim: data[index]['pengurus_nim'],
                                );
                              });
                        } else {
                          bloc.getAllAgenda();
                          return AlertDialog(
                            elevation: 0,
                            content: Container(
                                width: 50,
                                height: 50,
                                child: SpinKitThreeBounce(
                                  color: Colors.lime[900],
                                )),
                          );
                        }
                      })),
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
      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
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
