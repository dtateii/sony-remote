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
        primaryColor: Colors.black,
        accentColor: Colors.white,
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
      fontSize: 24.0,
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

  static TextStyle buttonYellow (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 46.0,
      color: Color(0xFFebff4e),
    );
  }

  static TextStyle buttonRed (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 46.0,
      color: Color(0xFFff206f),
    );
  }

}

class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {

  bool _isWorking = false;

  void checkNetwork(context) async {

    setState(() {
      _isWorking = true;
    });

    var connectivityResult = await (new Connectivity().checkConnectivity());

    if ( connectivityResult != ConnectivityResult.wifi) {
      print('No wifi.');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenErrorWifi()),
      );
    } else {
      print('Network test passed.');

      // Todo: Need to handle unresponsive device.

      // Only proceed to Screen if power is on standby.
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
    _isWorking = false;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        checkNetwork(context);
      },
      child: Scaffold(
        body: Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:70),
                      child: Text(
                        'I / O',
                        style: CustomTextStyle.label(context),
                      )
                    ),
                    Container (
                      padding: const EdgeInsets.only(top: 340),
                      child: (_isWorking
                        ? CircularProgressIndicator()
                        : Image.asset('assets/logo-nji-white.png', width: 240)
                      ),
                    )
                  ],
                )
              ),
            ]
          )
        )
      )
    );
  }
}

class ScreenSource extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top:20),
                    child: Text(
                      'SOURCE',
                      style: CustomTextStyle.label(context),
                    )
                  ),
                  Container (
                    padding: const EdgeInsets.only(top: 100),
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sources List...',
                      style: CustomTextStyle.button(context),
                        ),
                    ),
                  )
                ],
              )
            ),
          ]
        )
      )
    );
  }
}

class ScreenErrorWifi extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top:20),
                    child: Text(
                      'NO NETWORK',
                      style: CustomTextStyle.label(context),
                    )
                  ),
                  Container (
                    padding: const EdgeInsets.only(top: 100),
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Uh Oh. Need wifi.',
                      style: CustomTextStyle.buttonRed(context),
                        ),
                    ),
                  )
                ],
              )
            ),
          ]
        )
      )
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
      appBar: AppBar(),
      body: new FutureBuilder(
        future: _getPowerStatus(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              throw('API Error');
            } else {
              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top:20),
                          child: ( snapshot.data['status'] == 'standby'
                            ? Text(
                              'RECEIVER IS OFF',
                              style: CustomTextStyle.label(context),
                            )
                            : Text(
                              'RECEIVER IS ON',
                              style: CustomTextStyle.label(context),
                            )
                          )
                        ),
                        Container(
                          padding: const EdgeInsets.only(top:200),
                          child: ( snapshot.data['status'] == 'standby'
                            ? RaisedButton(
                              color: Colors.transparent,
                              onPressed: () {
                                _powerUp(context);
                              },
                              child: Text(
                                'Power Up',
                                style: CustomTextStyle.buttonYellow(context),
                              ),
                            )
                            : RaisedButton(
                              color: Colors.transparent,
                              onPressed: () {
                                _powerDown(context);
                              },
                              child: Text(
                                'Power Down',
                                style: CustomTextStyle.buttonRed(context),
                              ),
                            )
                          )
                        )
                      ]
                    )
                  )
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}
