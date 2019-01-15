import 'package:flutter/material.dart';

class CustomTextStyle {
  static TextStyle label (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 18.0,
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

  static TextStyle buttonYellow (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 34.0,
      color: Color(0xFFebff4e),
    );
  }

  static TextStyle buttonRed (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 34.0,
      color: Color(0xFFf41056),
    );
  }

  static TextStyle buttonGreen (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 34.0,
      color: Color(0xFF21ffbb),
    );
  }

  static TextStyle buttonDisabled (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 34.0,
      fontStyle: FontStyle.italic,
      color: Color(0xFF999999),
    );
  }

  static TextStyle detail (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 16.0,
      color: Color(0xFF999999),
    );
  }
}