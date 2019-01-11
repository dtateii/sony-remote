import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

var receiverAPI = 'http://192.168.86.243:10000/sony/'; // avContent';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // Full-screen.
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      title: 'NJI I/O',
      theme: ThemeData (
        canvasColor: Colors.black,
        cardColor: Colors.black,
        primaryColor: Colors.white,
        fontFamily: 'Open Sans',
      ),
      home: new FirstScreen(),
    );
  }
}

class CustomTextStyle {
  static TextStyle label (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.normal,
      fontSize: 28.0,
      color: Colors.white30,
    );
  }

  static TextStyle button (BuildContext context) {
    return Theme.of(context).textTheme.display4.copyWith(
      fontWeight: FontWeight.w100,
      fontSize: 46.0,
      color: Colors.white,
    );
  }

}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => new Scaffold(
//     body: new Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         new Card(
//           child: new Container(
//             child: new Text(
//               'NJI Media',
//               style: CustomTextStyle.button(context),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'I / O',
          style: CustomTextStyle.label(context),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.transparent,
          child: Text(
            'NJI Media',
            style: CustomTextStyle.button(context),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SetupPage()),
            );
          }
        ),
      ),
    );
  }
}

class ErrorScreenWifi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
        'NO NETWORK',
          style: CustomTextStyle.label(context),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Uh oh. Need Wifi.',
          style: CustomTextStyle.button(context),
            ),
        ),
      ),
    );
  }
}


class SetupPage extends StatefulWidget {
  @override
  _SetupPageState createState() => new _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
      print(_connectionStatus);
      if (result == ConnectivityResult.none) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ErrorScreenWifi()),
        );
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getData() async {
    http.Response response =
        await http.get("https://jsonplaceholder.typicode.com/posts/");
    if (response.statusCode == HttpStatus.ok) {
      var result = jsonDecode(response.body);
      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text("Connectivity")),
        body: new FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var mydata = snapshot.data;
              return new ListView.builder(
                itemBuilder: (context, i) => new ListTile(
                      title: Text(
                        mydata[i]['title'],
                        style: CustomTextStyle.label(context),
                      ),
                      // subtitle: Text(mydata[i]['body']),
                    ),
                itemCount: mydata.length,
              );
            } else {
              return Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}