import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'home.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[200],
  primaryColorBrightness: Brightness.light,
);

final ThemeData kAndroidTheme = new ThemeData(
  primarySwatch: Colors.teal,
  primaryColor: Colors.teal[400],
  accentColor: Colors.deepPurpleAccent[700],
);

class FlutterChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Friendly Chat",
      theme: defaultTargetPlatform == TargetPlatform.iOS ?
        kIOSTheme :
        kAndroidTheme,
      home: new ChatScreen(),
    );
  }
}
