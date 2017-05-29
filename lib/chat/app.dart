import 'package:flutter/material.dart';
import 'home.dart';

class FlutterChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendly Chat",
      home: new ChatScreen(),
    );
  }
}
