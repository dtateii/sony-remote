import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'dart:async';
import 'splash.dart';

// todo: Improve streamSubscription for timer to allow
// passing "short" restart timing, ultimately remove
// `restartShort` command.

class TimeOut extends StatefulWidget {

  final Stream timeOutStream;
  TimeOut({@required this.timeOutStream});

  @override
  createState() =>_TimeOutState();

}

class _TimeOutState extends State<TimeOut> {

  final timeOutInSeconds = 15;
  final stepInSeconds = 1;
  int currentNumber = 0;
  var sub;
  StreamSubscription streamSubscription;

  @override
  initState() {
    super.initState();
    streamSubscription = widget.timeOutStream.listen((command) {
      switch(command) {
        case 'start':
          startTimer();
          break;
        case 'restart':
          restartTimer();
          break;
        case 'restartShort':
          restartTimer(4);
          break;
        case 'stop':
          stopTimer();
          break;
      }
    });
  }

  @override
  didUpdateWidget(TimeOut old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.timeOutStream != old.timeOutStream) {
      streamSubscription.cancel();
      streamSubscription = widget.timeOutStream.listen((command) {
        switch(command) {
          case 'start':
            startTimer();
            break;
          case 'restart':
            restartTimer();
            break;
          case 'restartShort':
            restartTimer(4);
            break;
          case 'stop':
            stopTimer();
            break;
        }
      });
    }
  }

  @override
  void dispose() {
    sub.cancel();
    streamSubscription.cancel();
    super.dispose();
  }

  setupCountdownTimer([duration]) {
    // Allow default timeOutInSeconds to be
    // overridden by a passed duration param.
    var timeOutDuration = duration;
    if (timeOutDuration == null) {
      timeOutDuration = timeOutInSeconds;
    }
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: timeOutDuration),
      new Duration(seconds: stepInSeconds)
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      currentNumber += stepInSeconds;
      this._onTimerTick(currentNumber);
    });

    sub.onDone(() {
      print("Time out. Reset to Home display.");
      sub.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScreenSplash()),
      );
    });
  }

  void _onTimerTick(int currentNumber) {
    print('Now ' + currentNumber.toString() + ' seconds...');
    setState(() {
      currentNumber = currentNumber;
    });
  }

  void startTimer() {
    print('Starting timer...');
    setupCountdownTimer();
  }

  void restartTimer([duration]) {
    print('Restarting timer...');
    sub.cancel();
    currentNumber = 0;
    // By default, timer will reset to `timeOutInSeconds`,
    // unless optional param `duration` passed.
    if (duration != null) {
      setupCountdownTimer(duration);
    } else {
      setupCountdownTimer();
    }
  }

  void stopTimer() {
    print('Timer stopped.');
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
