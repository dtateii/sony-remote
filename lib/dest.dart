import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'theme.dart';
import 'config.dart' as appConf;
import 'package:http/http.dart' as http;
import 'audioControls.dart';
import 'model.dart';

class ScreenDest extends StatefulWidget {

  final StreamController timeOutStreamController;
  ScreenDest({@required this.timeOutStreamController});

  @override
  _DestState createState() => _DestState();
}

class _DestState extends State<ScreenDest> {

  bool _isWaiting = false;

  Future _pickDest(value) async {

    // Interaction occurred; restart the TimeOut timer.
    widget.timeOutStreamController.sink.add('restartShort');

    _isWaiting = true;
    setState(() {});

    String input;
    // Set the true input value depending on if it was
    // chosen directly (source) or indirectly (method).
    switch (IO.source) {
      case 'confmac':
      case 'appletv':
      case 'meet':
        input = IO.source;
        break;
      case 'macbook':
      case 'pc':
        (IO.method == 'airplay')
        ? input = 'appletv'
        : input = IO.method;
        break;
    }
    print("Config: " + IO.source + " via " + IO.method);
    print('Input determined: ' + input);
    print('Dest picked: ' + value);

    var response;
    var inputUri = appConf.Routing.getUri(input);
    var outputUri = appConf.Routing.getUri(value);
    response = await http.post(
      appConf.Api.getUri("avContent"),
      body: '{"method": "setPlayContent","id": 65,"params": [{"output":"' + outputUri + '", "uri":"' + inputUri + '"}],"version": "1.2"}');
    if (200 == response.statusCode) {
      var apiRes = jsonDecode(response.body);
      print('API response: ');
      print(apiRes);
    } else {
      print('http error');
    }

  }

  // Back from here is either Source or Method.
  // Need to restart the timer in either case.
  Future<bool> _willPopCallback() async {
    widget.timeOutStreamController.sink.add('restart');
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top:14),
                      child: ( _isWaiting
                        ? Text(
                            'HOLD ON TO YOUR BUTT',
                            style: CustomTextStyle.label(context),
                          )
                        : Text(
                            'DESTINATION',
                            style: CustomTextStyle.label(context),
                          )
                      )
                    ),
                    ( _isWaiting
                      ? Container(
                        padding: const EdgeInsets.only(top:260),
                        child: CircularProgressIndicator(),
                      )
                      : Container(
                        padding: const EdgeInsets.only(top:100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FlatButton(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Text('TV', style: CustomTextStyle.button(context)),
                              onPressed: () {
                                _pickDest('tv');
                              },
                            ),
                            FlatButton(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Text('Projector', style: CustomTextStyle.button(context)),
                              onPressed: () {
                                _pickDest('projector');
                              },
                            ),
                            // FlatButton(
                            //   padding: const EdgeInsets.only(bottom: 40),
                            //   child: ( _isAudioAllowed
                            //     ? Text(
                            //       'Speakers',
                            //       style: CustomTextStyle.button(context))
                            //     : Text(
                            //       'Speakers',
                            //       style: CustomTextStyle.buttonDisabled(context))
                            //   ),
                            //   onPressed: () {
                            //     if(_isAudioAllowed) {
                            //       _pickDest('audio');
                            //     }
                            //   },
                            // ),
                          ]
                        ),
                      )
                    )
                  ],
                )
              ),
            ]
          )
        ),
        bottomSheet: AudioControls(),
      )
    );
  }
}
