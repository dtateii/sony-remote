import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

var receiverAPI = 'http://192.168.86.27:10000/sony/';

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
      home: new ScreenSplash(),
    );
  }
}

class CustomTextStyle {
  static TextStyle label (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 22.0,
      color: Colors.white30,
    );
  }

  static TextStyle button (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 46.0,
      color: Colors.white,
    );
  }
}

class ScreenSplash extends StatelessWidget {

  void checkNetwork(context) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if ( connectivityResult != ConnectivityResult.wifi) {
      print('No wifi.');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenErrorWifi()),
      );
    } else {
      print('Network test passed.');
      // Only proceed to Power Screen if power is on standby.
      http.post(
      receiverAPI + "system",
      body: '{"method": "getPowerStatus","id": 65,"params": [],"version": "1.1"}')
      .then((response){
        if (200 == response.statusCode) {
          var apiRes = jsonDecode(response.body);
          if (apiRes['result'][0]['status'] == "active") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenSource()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenPower()),
            );
          }
        }
      });
    }
  }

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
            checkNetwork(context);
          }
        ),
      ),
    );
  }
}

class ScreenSource extends StatelessWidget {
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
            'Source Selection...',
          style: CustomTextStyle.button(context),
            ),
        ),
      ),
    );
  }
}

class ScreenErrorWifi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'NO NETWORK',
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
            'Uh oh. Need Wifi.',
          style: CustomTextStyle.button(context),
            ),
        ),
      ),
    );
  }
}

class ScreenPower extends StatelessWidget {

  Future _getPowerStatus(context) async {
    var response = await http.post(
      receiverAPI + "system",
      body: '{"method": "getPowerStatus","id": 65,"params": [],"version": "1.1"}');
    if (200 == response.statusCode) {
      var apiRes = jsonDecode(response.body);
      return apiRes['result'][0];
    } else {
      return false;
    }
  }

  Future _powerUp(context) async {
    var response = await http.post(
      receiverAPI + "system",
      body: '{"method": "setPowerStatus","id": 65,"params": [{"status":"active"}],"version": "1.1"}');
    if (200 == response.statusCode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenSource()),
      );
    }
  }

  Future _powerDown(context) async {
    var response = await http.post(
      receiverAPI + "system",
      body: '{"method": "setPowerStatus","id": 65,"params": [{"status":"off"}],"version": "1.1"}');
    if (200 == response.statusCode) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenSplash()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(
        'POWER',
          style: CustomTextStyle.label(context),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: new FutureBuilder(
          future: _getPowerStatus(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                throw('API Error');
              } else {
                if (snapshot.data['status'] == 'standby') {
                  return Center(
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        _powerUp(context);
                      },
                      child: Text(
                        'Power Up',
                        style: CustomTextStyle.button(context),
                      ),
                    ),
                  );
                }
                if (snapshot.data['status'] == 'active') {
                  return Center(
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        _powerDown(context);
                      },
                      child: Text(
                        'Power Down',
                        style: CustomTextStyle.button(context),
                      ),
                    ),
                  );
                }
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        )
      )
    );
  }
}
