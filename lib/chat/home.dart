import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Chat"),
      ),
      body: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: new Row(children: <Widget>[
        new Flexible(
          child: new TextField(
            controller: _textController,
            onSubmitted: _handleMessageSubmit,
            decoration: new InputDecoration.collapsed(hintText: "Send a Message"),
          ),
        ),
        new IconTheme(
          data: new IconThemeData(color: Theme.of(context).accentColor),
          child: new Container(
            child: new IconButton(
              icon: new Icon(Icons.send),
              onPressed: () => _handleMessageSubmit(_textController.text),
            ),
          ),
        ),
      ]),
    );
  }

  void _handleMessageSubmit(String text) {
    _textController.clear();
  }
}
