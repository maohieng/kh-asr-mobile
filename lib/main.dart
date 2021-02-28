import 'dart:async';

import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/AnimationScreen.dart';
import 'package:niptict_asr_app/ui/widget/MainPage.dart';

import 'ui/HomeScreen.dart';
import 'ui/SpeechRecognitionScreen.dart';


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
        child: Stack(
        children: <Widget>[
        Scaffold(
       
    body: MainPage()
    ),
    IgnorePointer(
    child: AnimationScreen(
    color: Theme.of(context).accentColor
    )
    )
    ]
    )
    ));
  }



}