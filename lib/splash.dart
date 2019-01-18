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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScreenSource()),
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