import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        primaryColor: Colors.white,
        fontFamily: 'Open Sans',
      ),
      home: new HomePage(),
    );
  }
}

class CustomTextStyle {
  static TextStyle display5(BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 34.0,
      color: Colors.white,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        new Card(
          child: new Container(

            child: new Text(
              'NJI Media',
              style: CustomTextStyle.display5(context),
            ),
          ),
        ),
      ],
    ),
  );
}
