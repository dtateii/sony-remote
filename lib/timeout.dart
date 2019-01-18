import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'splash.dart';

class TimeOut extends StatefulWidget {
  @override
  _TimeOutState createState() => _TimeOutState();
}

class _TimeOutState extends State<TimeOut> {

  final timeOutInSeconds = 10;
  final stepInSeconds = 5;
  int currentNumber = 0;
  var sub;

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  _TimeOutState() {
    setupCountdownTimer();
  }

  setupCountdownTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: timeOutInSeconds),
      new Duration(seconds: stepInSeconds)
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      currentNumber += stepInSeconds;
      this.onTimerTick(currentNumber);
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

  void onTimerTick(int currentNumber) {
    setState(() {
      currentNumber = currentNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
