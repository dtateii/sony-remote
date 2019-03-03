import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'theme.dart';
import 'config.dart' as appConf;
import 'errorWifi.dart';
import 'errorNoResponse.dart';
import 'source.dart';
import 'power.dart';
import 'timeout.dart';

class ScreenSplash extends StatefulWidget {
  @override
  _ScreenSplashState createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {

  final timeOutStreamController = new StreamController.broadcast();
  bool _isWorking = false;


  @override
  void dispose() {
    print('dispose Splash called.');
    timeOutStreamController.close();
    super.dispose();
  }

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
      print('Wifi on.');

      // Only proceed to Screen if power is on standby.
      try {
        var response = await http.post(
          appConf.Api.getUri("system"),
          body: '{"method": "getPowerStatus","id": 65,"params": [],"version": "1.1"}')
          .timeout(new Duration(seconds: 6));

        if (200 == response.statusCode) {
          var apiRes = jsonDecode(response.body);
          if (apiRes['result'][0]['status'] == "active") {
            print('Receiver is Active.');
            // Next screen is source. Start the TimeOut timer for this screen.
            timeOutStreamController.sink.add('start');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenSource(timeOutStreamController: timeOutStreamController)),
            );
          } else {
            print('Receiver on Standby.');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenPower()),
            );
          }
        }
      } on TimeoutException catch (_) {
        print('Receiver is unresponsive.');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScreenErrorNoResponse()),
        );
      }

    }
    _isWorking = false;
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        // Don't necessarily start timer on any tap event -- possible
        // error screen could be next, and shouldn't timeout/reset.
        checkNetwork(context);
      },
      child: Scaffold(
        body: Container(
          child: Row(
            children: [
              TimeOut(timeOutStream: timeOutStreamController.stream),
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
                      padding: const EdgeInsets.only(top: 290),
                      child: (_isWorking
                        ? CircularProgressIndicator()
                        : Image.asset('assets/logo-nji-white.png', width: 180)
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
