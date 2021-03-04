//UploadVoice
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/SpeechRecognitionScreen.dart';
import 'package:niptict_asr_app/utils/HexColor.dart';

import '../VoiceUploadScreen.dart';
import '../AboutUsScreen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var switch_screen = 1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Image.asset(
                    'assets/images/KhAsrLogo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                  leading: Icon(Icons.keyboard_voice, color: Colors.indigo),
                  title: Text('បំលែងសំឡេងនិយាយ'),
                  onTap: () {
                    setState(() {
                      switch_screen = 1;
                    });
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: Icon(Icons.upload_file, color: Colors.indigo),
                  title: Text('បំលែងឯកសារនិយាយ'),
                  onTap: () {
                    setState(() {
                      switch_screen = 2;
                    });
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: Icon(Icons.info, color: Colors.indigo),
                  title: Text('អំពីយើង'),
                  onTap: () {
                    setState(() {
                      switch_screen = 3;
                    });
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('កម្មវិធីបំលែងសំលេងទៅជាអត្ថបទ',
                      style: TextStyle(fontFamily: "KhMuol", fontSize: 14))),
            ],
          ),
          centerTitle: true,
          backgroundColor: HexColor('#0D47A1'),
          shadowColor: Colors.transparent,
        ),
        body: routeScreen(switch_screen));
  }

  Widget routeScreen(switchScreen) {
    switch (switchScreen) {
      case 1:
        return SpeechRecognitionScreen();
        break;
      case 2:
        return VoiceUploadScreen();
        break;
      default:
        return AboutUsScreen();
        break;
    }
  }
}
