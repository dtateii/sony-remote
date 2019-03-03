import 'package:flutter/material.dart';
import 'dart:async';
import 'theme.dart';
import 'audioControls.dart';
import 'dest.dart';
import 'model.dart';

class ScreenMethod extends StatefulWidget {

  final StreamController timeOutStreamController;
  ScreenMethod({@required this.timeOutStreamController});

  @override 
  _MethodState createState() => _MethodState();
}

class _MethodState extends State<ScreenMethod> {

  _pickMethod(value) {
    IO.method = value;
    print('method picked: ' + value);
  
    // Interaction occurred; restart the TimeOut timer.
    widget.timeOutStreamController.sink.add('restart');

     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenDest(timeOutStreamController: widget.timeOutStreamController)),
    );
  }

  // Back from here is always Source Screen.
  // Need to restart the time in this case.
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
                      child: Text(
                        'METHOD',
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
                            child: Text('ChromeCast', style: CustomTextStyle.button(context)),
                            onPressed: () {
                              _pickMethod('chromecast');
                            },
                          ),
                          (IO.source != 'pc'
                            ? FlatButton(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Text('AppleTV', style: CustomTextStyle.button(context)),
                                onPressed: () {
                                  _pickMethod('appletv');
                                },
                              )
                            : Container()
                          ),
                          // FlatButton(
                          //   padding: const EdgeInsets.only(bottom: 40),
                          //   child: Text('HDMI', style: CustomTextStyle.button(context)),
                          //   onPressed: () {
                          //     _pickMethod('hdmi');
                          //   },
                          // ),
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
      )
    );
  }
}
