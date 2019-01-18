import 'package:flutter/material.dart';
import 'dart:convert';
import 'theme.dart';
import 'config.dart' as appConf;
import 'package:http/http.dart' as http;
import 'audioControls.dart';
import 'timeout.dart';
import 'model.dart';

class ScreenDest extends StatefulWidget {
  @override
  _DestState createState() => _DestState();
}

class _DestState extends State<ScreenDest> {

  // bool _isAudioAllowed = true;
  bool _isWaiting = false;
  // bool _isCurrentlyRouted = false;

  Future _delay() {
    _isWaiting = true;
    setState(() {});
    return new Future.delayed(const Duration(seconds: 5), () {
      _isWaiting = false;
      setState(() {});
    });
  }

  Future _pickDest(value) async {

    await _delay();

    print(IO.source + " via " + IO.method);
    print('dest picked: ' + value);

    String input;

    // Set the true input value depending on if it was
    // directly (source) or indirectly (method) picked.
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

    var response;
    // Here activate zone if needed.
    // Todo: check to see if it's needed.
    // Activate HDMI Zone.
    // if (value == 'tv') {
    //   print('TV is currently in HDMI zone. Making sure zone is activated.');
    //   response = await http.post(
    //     appConf.Api.getUri("avContent"),
    //     body: '{"method":"setActiveTerminal","id":65,"params":[{"active":"active","uri":"extOutput:zone?zone=4"}],"version":"1.0"}');
    //   if (200 == response.statusCode) {
    //     var apiRes = jsonDecode(response.body);
    //     print(apiRes);
    //   } else {
    //     print('http error');
    //   }
    // }
  
    var inputUri = appConf.Routing.getUri(input);
    var outputUri = appConf.Routing.getUri(value);
    response = await http.post(
      appConf.Api.getUri("avContent"),
      body: '{"method": "setPlayContent","id": 65,"params": [{"output":"' + outputUri + '", "uri":"' + inputUri + '"}],"version": "1.2"}');
    if (200 == response.statusCode) {
      var apiRes = jsonDecode(response.body);
      print(apiRes);
    } else {
      print('http error');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Row(
          children: [
            TimeOut(),
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
    );
  }
}
