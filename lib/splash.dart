import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'theme.dart';
import 'config.dart' as appConf;
import 'errorWifi.dart';
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
      print('Network test passed.');

      // Todo: Need to handle unresponsive device.

      // Only proceed to Screen if power is on standby.
      http.post(
      appConf.Api.getUri("system"),
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