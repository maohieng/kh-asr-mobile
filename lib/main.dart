import 'package:flutter/material.dart';
import 'package:khmerasr/ui/AnimationScreen.dart';
import 'package:khmerasr/ui/widget/MainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Material(
            child: Stack(children: <Widget>[
          Scaffold(body: MainPage()),
          IgnorePointer(
              child: AnimationScreen(color: Theme.of(context).accentColor))
        ])));
  }
}
