import 'package:flutter/material.dart';
import 'dart:convert';
import 'theme.dart';
import 'config.dart' as appConf;
import 'package:http/http.dart' as http;
import 'audioControls.dart';
import 'model.dart';

class ScreenDest extends StatefulWidget {
  @override
  _DestState createState() => _DestState();
}

class _DestState extends State<ScreenDest> {

  // bool _isAudioAllowed = true;

  Future _pickDest(value) async {
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

    var inputUri = appConf.Routing.getUri(input);
    var outputUri = appConf.Routing.getUri(value);
    var response = await http.post(
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top:14),
                    child: Text(
                      'DESTINATION',
                      style: CustomTextStyle.label(context),
                    )
                  ),
                  Container(
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
                  ),
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
