import 'package:flutter/material.dart';

class DetailArticleView extends StatefulWidget {
  final dynamic data;
  DetailArticleView({Key key, this.data}) : super(key: key);

  @override
  _DetailArticleViewState createState() => _DetailArticleViewState();
}

class _DetailArticleViewState extends State<DetailArticleView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.data['title']),
        ),
        body: Column(
          children: <Widget>[
            Image(image: NetworkImage(widget.data['image'])),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                widget.data['content'],
                textAlign: TextAlign.justify,
              ),
            )
          ],
        ));
  }
}
