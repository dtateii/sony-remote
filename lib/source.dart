import 'package:flutter/material.dart';
import 'theme.dart';

class ScreenSource extends StatelessWidget {

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
                      'SOURCE',
                      style: CustomTextStyle.label(context),
                    )
                  ),
                  Container (
                    padding: const EdgeInsets.only(top: 100),
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sources List...',
                      style: CustomTextStyle.button(context),
                        ),
                    ),
                  )
                ],
              )
            ),
          ]
        )
      )
    );
  }
}