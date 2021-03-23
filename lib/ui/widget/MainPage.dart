//UploadVoice
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khmerasr/ui/SpeechRecognitionScreen.dart';
import 'package:khmerasr/utils/HexColor.dart';

import '../VoiceUploadScreen.dart';
import '../AboutUsScreen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var switchScreen = 1;
  var _titleBar = 'បំលែងសំឡេងនិយាយទៅជាអត្ថបទ';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Image.asset('assets/images/logo_app_final.png',
                      fit: BoxFit.contain, height: 130),
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
                      _titleBar = 'បំលែងសំឡេងនិយាយទៅជាអត្ថបទ';
                      switchScreen = 1;
                    });
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: Icon(Icons.upload_file, color: Colors.indigo),
                  title: Text('បំលែងឯកសារសំឡេង'),
                  onTap: () {
                    setState(() {
                      _titleBar = 'បំលែងឯកសារសំឡេងទៅជាអត្ថបទ';
                      switchScreen = 2;
                    });
                    Navigator.of(context).pop();
                  }),
              ListTile(
                  leading: Icon(Icons.info, color: Colors.indigo),
                  title: Text('អំពីយើង'),
                  onTap: () {
                    setState(() {
                      _titleBar = 'អំពីយើង';
                      switchScreen = 3;
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
                  child: Text(_titleBar,
                      style: TextStyle(fontFamily: "KhMuol", fontSize: 14))),
            ],
          ),
          centerTitle: true,
          backgroundColor: HexColor('#0D47A1'),
          shadowColor: Colors.transparent,
        ),
        body: routeScreen(switchScreen));
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
