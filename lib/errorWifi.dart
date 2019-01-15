import 'package:flutter/material.dart';
import 'theme.dart';

class ScreenErrorWifi extends StatelessWidget {

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
                      'NO NETWORK',
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
                        "Please connect to the NJI Media wireless network.\n\nAlternatively, I/O can be switched manually on the Sony STR-DN1080 receiver.",
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