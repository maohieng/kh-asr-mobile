import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khmerasr/ui/AnimationScreen.dart';
import 'package:khmerasr/ui/widget/MainPage.dart';
import 'package:khmerasr/utils/HexColor.dart';

void main() {
  // disable screen orientation
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

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
          IgnorePointer(child: AnimationScreen(color: HexColor('#9fcaf5')))
        ])));
  }
}
