import 'package:flutter/material.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  bool _isComposing = false;
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter Chat"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
          child: new Container(
            child: new ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
              reverse: true,
            ),
            padding: new EdgeInsets.all(10.0),
          ),
        ),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      margin: new EdgeInsets.symmetric(horizontal: 10.0),
      child: new Row(children: <Widget>[
        new Flexible(
          child: new Container(
            padding: new EdgeInsets.symmetric(vertical: 10.0),
            child: new TextField(
              controller: _textController,
              onSubmitted: _handleMessageSubmit,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a Message"
              ),
              onChanged: (String text) {
                setState(() => _isComposing = text.length > 0);
              },
              autofocus: true,
              maxLines: 9999, // TODO: Theoretical Limit (is there another solution)
              // See GitHub Issue https://github.com/flutter/flutter/issues/10006
            ),
          ),
        ),
        new Container(
          child: new IconButton(
            icon: new Icon(Icons.send),
            color: Theme.of(context).accentColor,
            onPressed: _isComposing ?
              () => _handleMessageSubmit(_textController.text) :
              null,
          ),
        ),
      ]),
    );
  }

  void _handleMessageSubmit(String text) {
    _textController.clear();
    setState(() => _isComposing = false);
    ChatMessage message = new ChatMessage(
      messageText: text,
      animationController: new AnimationController(
        vsync: this,
        duration: new Duration(milliseconds: 1000),
      ),
    );
    setState(() => _messages.insert(0, message));
    message.animationController.forward();
  }

  // Good Practice to Dispose Animations
  @override
  void dispose() {
    for(ChatMessage message in _messages) {
      message.animationController.dispose();
      super.dispose();
    }
  }
}
