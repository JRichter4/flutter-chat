import 'package:flutter/material.dart';

const String _name = "Joey";

class ChatMessage extends StatelessWidget {
  final String _messageText;

  ChatMessage(this._messageText);

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 8.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: new CircleAvatar(child: new Text(_name[0])),
            margin: new EdgeInsets.only(right: 15.0),
          ),
          new Flexible(child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(_name, style: Theme.of(context).textTheme.subhead),
              new Container(
                margin: new EdgeInsets.only(top: 5.0),
                child: new Text(_messageText),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
