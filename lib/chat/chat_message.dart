import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class ChatMessage extends StatelessWidget {
  final DataSnapshot snapshot;
  final Animation animation;

  ChatMessage({
    @required this.snapshot,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: new EdgeInsets.symmetric(vertical: 8.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: new GoogleUserCircleAvatar(snapshot.value['senderPhotoUrl']),
              margin: new EdgeInsets.only(right: 15.0),
            ),
            new Flexible(child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  snapshot.value['senderName'],
                  style: Theme.of(context).textTheme.subhead
                ),
                new Container(
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Text(snapshot.value['messageText']),
                ),
              ],
            )),
          ],
        ),
      )
    );
  }
}
