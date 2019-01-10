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
      home: new FirstScreen(),
    );
  }
}

class CustomTextStyle {
  static TextStyle label (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
      color: Colors.white30,
    );
  }

  static TextStyle button (BuildContext context) {
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
              style: CustomTextStyle.button(context),
            ),
          ),
        ),
      ],
    ),
  );
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'I / O',
          style: CustomTextStyle.label(context),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.transparent,
          child: Text(
            'NJI Media',
            style: CustomTextStyle.button(context),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondScreen()),
            );
          }
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'SOURCE',
          style: CustomTextStyle.label(context),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Back',
          style: CustomTextStyle.button(context),
            ),
        ),
      ),
    );
  }
}