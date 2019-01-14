import 'package:flutter/material.dart';
import 'theme.dart';
import 'audioControls.dart';
import 'dest.dart';
import 'model.dart';

class ScreenMethod extends StatefulWidget {
  @override
  _MethodState createState() => _MethodState();
}

class _MethodState extends State<ScreenMethod> {

  _pickMethod(value) {
    IO.method = value;
    print('method picked: ' + value);
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenDest()),
    );
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
                    padding: const EdgeInsets.only(top:20),
                    child: Text(
                      'METHOD',
                      style: CustomTextStyle.label(context),
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.only(top:160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text('AirPlay', style: CustomTextStyle.button(context)),
                          onPressed: () {
                            _pickMethod('airplay');
                          },
                        ),
                        FlatButton(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text('ChromeCast', style: CustomTextStyle.button(context)),
                          onPressed: () {
                            _pickMethod('chromecast');
                          },
                        ),
                        FlatButton(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text('HDMI', style: CustomTextStyle.button(context)),
                          onPressed: () {
                            _pickMethod('hdmi');
                          },
                        ),
                        FlatButton(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text('Google Meet', style: CustomTextStyle.button(context)),
                          onPressed: () {
                            _pickMethod('meet');
                          },
                        ),
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
