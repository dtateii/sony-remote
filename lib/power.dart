import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'theme.dart';
import 'config.dart' as appConf;
import 'splash.dart';
import 'source.dart';

class ScreenPower extends StatelessWidget {

  Future _getPowerStatus(context) async {
    var response = await http.post(
      appConf.Api.getUri("system"),
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
      appConf.Api.getUri("system"),
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
      appConf.Api.getUri("system"),
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
                          padding: const EdgeInsets.only(top:14),
                          child: ( snapshot.data['status'] == 'standby'
                            ? Text(
                              'RECEIVER ON STANDBY',
                              style: CustomTextStyle.label(context),
                            )
                            : Text(
                              'RECEIVER ACTIVE',
                              style: CustomTextStyle.label(context),
                            )
                          )
                        ),
                        Container(
                          padding: const EdgeInsets.only(top:170),
                          child: ( snapshot.data['status'] == 'standby'
                            ? Image.asset('assets/icon-power-up.png', width: 52)
                            : Image.asset('assets/icon-power-down.png', width: 52)
                          )
                        ),
                        Container(
                          padding: const EdgeInsets.only(top:20),
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