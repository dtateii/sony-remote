import 'package:flutter/material.dart';
import 'theme.dart';

class AudioControls extends StatefulWidget {
  @override
  _AudioControlsState createState() => _AudioControlsState();
}

class _AudioControlsState extends State<AudioControls> {

  // double _volume = 10;

  volumeChange(){
    print('change volume');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      // child: Slider(
      //   min: 0,
      //   max: 80,
      //   onChanged: volumeChange(),
      //   value: _volume,
      // )
      child: Text('', style: CustomTextStyle.label(context))
    );
  }
}
