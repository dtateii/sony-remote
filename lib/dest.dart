import 'package:flutter/material.dart';
import 'theme.dart';
import 'audioControls.dart';
import 'model.dart';

class ScreenDest extends StatefulWidget {
  @override
  _DestState createState() => _DestState();
}

class _DestState extends State<ScreenDest> {

  _pickDest(value) {
    print(IO.source + " via " + IO.method);
    print('dest picked: ' + value);
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
                      'DESTINATION',
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
                        FlatButton(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Text('Speakers', style: CustomTextStyle.button(context)),
                          onPressed: () {
                            _pickDest('audio');
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
