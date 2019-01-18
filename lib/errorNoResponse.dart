import 'package:flutter/material.dart';
import 'theme.dart';

class ScreenErrorNoResponse extends StatelessWidget {

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
                      'NO RESPONSE',
                      style: CustomTextStyle.label(context),
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.only(top:150),
                    child: Image.asset('assets/icon-wifi-no.png', width: 80)
                  ),
                  Container (
                    padding: const EdgeInsets.only(top: 20),
                    child: RaisedButton(
                      color: Colors.transparent,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Uh Oh.',
                      style: CustomTextStyle.buttonRed(context),
                        ),
                    ),
                  ),
                  Container (
                    padding: const EdgeInsets.only(top: 200, left: 30, right: 30),
                    child: Text(
                        "Unable to connect. Ensure Sony receiver is powered up, and ensure this device is connected to the internal (non-guest) NJI Media wifi network.",
                      style: CustomTextStyle.detail(context),
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