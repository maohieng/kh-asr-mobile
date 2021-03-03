//UploadVoice
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/SpeechRecognitionScreen.dart';
import 'package:niptict_asr_app/utils/HexColor.dart';

import '../VoiceUploadScreen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var switch_sreen = 1;
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
                  leading: Icon(Icons.keyboard_voice),
                  title: Text('បំលែងសំឡេងនិយាយ'),
                  onTap: () {
                    setState(() {
                      switch_sreen = 1;
                    });
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: Icon(Icons.upload_file),
                  title: Text('បំលែងឯកសារនិយាយ'),
                  onTap: () {
                    setState(() {
                      switch_sreen = 2;
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
        body: switch_sreen == 1
            ? SpeechRecognitionScreen()
            : VoiceUploadScreen());
  }
}
