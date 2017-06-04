
// Dart Imports
import 'dart:async';

// Package Imports
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Firebase Imports
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

// File Imports
import 'chat_message.dart';

// Globals
final GoogleSignIn gGoogleSignIn = new GoogleSignIn();
final FirebaseAnalytics gAnalytics = new FirebaseAnalytics();
final FirebaseAuth gFirebaseAuth = FirebaseAuth.instance;
final DatabaseReference gMessagesDbRef =
    FirebaseDatabase.instance.reference().child("messages");

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isComposing = false;
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
            child: new FirebaseAnimatedList(
              query: gMessagesDbRef,
              sort: (a, b) => b.key.compareTo(a.key),
              reverse: true,
              itemBuilder: (_, DataSnapshot snap, Animation<double> animation) {
                return new ChatMessage(
                  snapshot: snap,
                  animation: animation,
                );
              },
              duration: new Duration(milliseconds: 1000),
            ),
            padding: new EdgeInsets.all(10.0),
          ),
//          child: new Container(
//            child: new ListView.builder(
//              itemCount: _messages.length,
//              itemBuilder: (_, int index) => _messages[index],
//              reverse: true,
//            ),
//            padding: new EdgeInsets.all(10.0),
//          ),
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
              onSubmitted: _isComposing ? _handleMessageSubmit : null,
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
          child: Theme.of(context).platform == TargetPlatform.iOS
              ? new CupertinoButton(
                  child: new Text("Send"),
                  onPressed: _isComposing
                      ? () => _handleMessageSubmit(_textController.text)
                      : null,
                )
              : new IconButton(
                  icon: new Icon(Icons.send),
                  color: Theme.of(context).accentColor,
                  onPressed: _isComposing
                      ? () => _handleMessageSubmit(_textController.text)
                      : null,
              ),
        ),
      ]),
    );
  }

  Future<Null> _ensureLoggedIn() async {
    GoogleSignInAccount user = gGoogleSignIn.currentUser;

    user ?? await gGoogleSignIn.signInSilently();
    user ?? await gGoogleSignIn.signIn();
    gAnalytics.logLogin();

    if (gFirebaseAuth.currentUser == null) {
      GoogleSignInAuthentication credentials =
          await gGoogleSignIn.currentUser.authentication;
      await gFirebaseAuth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
  }

  Future<Null> _handleMessageSubmit(String text) async {
    _textController.clear();
    setState(() => _isComposing = false);
    await _ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({String text}) {
    gMessagesDbRef.push().set({
      'messageText': text,
      'senderName': gGoogleSignIn.currentUser.displayName,
      'senderPhotoUrl': gGoogleSignIn.currentUser.photoUrl,
    });
    gAnalytics.logEvent(name: "message_sent");
  }
}

//  void _sendMessage({String text}) {
//    ChatMessage message = new ChatMessage(
//      messageText: text,
//      animationController: new AnimationController(
//        vsync: this,
//        duration: new Duration(milliseconds: 1000),
//      ),
//      user: gGoogleSignIn.currentUser,
//    );
//    setState(() => _messages.insert(0, message));
//    message.animationController.forward();
//
//    gMessagesDbRef.push().set({
//      'messageText': text,
//      'senderName': gGoogleSignIn.currentUser.displayName,
//      'senderPhotoUrl': gGoogleSignIn.currentUser.photoUrl,
//    });
//    gAnalytics.logEvent(name: "message_sent");
//  }

  // Good Practice to Dispose Animations
//  @override
//  void dispose() {
//    for(ChatMessage message in _messages) {
//      message.animationController.dispose();
//      super.dispose();
//    }
//  }
