import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // Full-screen.
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: 'NJI I/O',
      theme: ThemeData (
        canvasColor: Colors.black,
        cardColor: Colors.black,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        fontFamily: 'Open Sans',
      ),
      home: new ScreenSplash(),
    );
  }
}
