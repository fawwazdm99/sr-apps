import 'package:flutter/material.dart';
import 'package:sr_apps/router/routerPage.dart';
import 'package:sr_apps/bloc/logic/L_profile.dart';

class ProfileView extends StatefulWidget {
  ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  static final bloc = Bloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        elevation: 0,
      ),
      backgroundColor: Colors.lime[900],
      body: ListView(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height / 1.1),
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(50))),
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                      future: bloc.getUserPref(),
                      builder: (context, snapshot) {
                        print(snapshot.data['picture']);
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                maxRadius: 30,
                                backgroundImage: snapshot.data['picture'] ==
                                        null
                                    ? AssetImage('assets/img/logo-sr.png')
                                    : NetworkImage(snapshot.data['picture']),
                              ),
                              Padding(padding: EdgeInsets.all(10)),
                              ProfileList(
                                title: 'NIM',
                                content: snapshot.data['nim'],
                              ),
                              ProfileList(
                                title: 'Nama',
                                content: snapshot.data['name'],
                              ),
                              ProfileList(
                                title: 'Jenis Kelamin',
                                content: snapshot.data['jenis_kelamin'],
                              ),
                              ProfileList(
                                title: 'Program Studi',
                                content: snapshot.data['study_program'],
                              ),
                              ProfileList(
                                title: 'Fakultas',
                                content: snapshot.data['faculty'],
                              ),
                              ProfileList(
                                title: 'Bidang Pembinaan',
                                content: snapshot.data['bidang'],
                              ),
                            ],
                          );
                        } else {
                          return Text('');
                        }
                      }),
                  Padding(padding: EdgeInsets.all(10)),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    elevation: 2,
                    child: InkWell(
                      onTap: () async {
                        String bidang_id = await bloc.getBidang();
                        Navigator.of(context).pushNamed(EditProfileViewRoute,
                            arguments: {'bidang_id': bidang_id});
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Edit Profil',
                                style: TextStyle(color: Colors.lime[900])),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.lime[900],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    elevation: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(EditPasswordViewRoute);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Ubah Password',
                                style: TextStyle(color: Colors.lime[900])),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.lime[900],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  RaisedButton(
                    onPressed: () async {
                      await bloc.logout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginViewRoute, (Route<dynamic> route) => false);
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.lime[900],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileList extends StatelessWidget {
  final String title;
  final String content;
  const ProfileList({
    Key key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            title.toString(),
            style:
                TextStyle(color: Colors.lime[900], fontWeight: FontWeight.bold),
          ),
          Text(content.toString()),
        ],
      ),
    );
  }
}
