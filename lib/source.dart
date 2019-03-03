import 'package:flutter/material.dart';
import 'dart:async';
import 'theme.dart';
import 'audioControls.dart';
import 'method.dart';
import 'dest.dart';
import 'model.dart';


class ScreenSource extends StatefulWidget {

  final StreamController timeOutStreamController;
  ScreenSource({@required this.timeOutStreamController});

  @override
  _SourceState createState() => _SourceState();
}

class _SourceState extends State<ScreenSource> {

  _pickSource(value, context) {

    IO.source = value;
    print('Source picked: ' + IO.source);

    // Interaction occurred; restart the TimeOut timer.
    widget.timeOutStreamController.sink.add('restart');

    switch (IO.source) {
      case 'confmac':
      case 'appletv':
      case 'meet':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScreenDest(timeOutStreamController: widget.timeOutStreamController)),
        );
        break;
      case 'macbook':
      case 'pc':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScreenMethod(timeOutStreamController: widget.timeOutStreamController)),
        );
        break;
    }
  }

  // Back from here is always Splash Screen.
  // Need to stop the timer in this case.
  Future<bool> _willPopCallback() async {
    widget.timeOutStreamController.sink.add('stop');
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
                      child: Text(
                        'SOURCE',
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
                            child: Text('Any Macbook', style: CustomTextStyle.button(context)),
                            onPressed: () {
                              _pickSource('macbook', context);
                            },
                          ),
                          FlatButton(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Text('Conf Room Mac', style: CustomTextStyle.button(context)),
                            onPressed: () {
                              _pickSource('confmac', context);
                            },
                          ),
                          FlatButton(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Text('AppleTV', style: CustomTextStyle.button(context)),
                            onPressed: () {
                              _pickSource('appletv', context);
                            },
                          ),
                          FlatButton(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Text('Google Meet', style: CustomTextStyle.button(context)),
                            onPressed: () {
                              _pickSource('meet', context);
                            },
                          ),
                          FlatButton(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: Text('Any PC', style: CustomTextStyle.button(context)),
                            onPressed: () {
                              _pickSource('pc', context);
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
      )
    );
  }
}
