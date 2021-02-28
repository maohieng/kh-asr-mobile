
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/SpeechRecognitionScreen.dart';
import 'package:niptict_asr_app/ui/widget/MainPage.dart';

class HomeScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              height: 110,

            ),
            Padding(
              padding: const EdgeInsets.only(top: 30,bottom: 50),
              child: Text('កម្មវិធីបំលែងពីសំលេងទៅជាអក្សរ',style: TextStyle(fontFamily: "KhMuol", fontSize: 18)),
            ),
            FlatButton.icon(
              icon: Icon(Icons.keyboard_voice_outlined),//icon image
              label: Text('Voice Streaming', style: TextStyle(fontFamily: "KhCon", fontSize: 16)),//text to show in button
              textColor: Colors.white,//button text and icon color.
              color: Colors.indigo,//button background color
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeechRecognitionScreen()),
                );
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.file_upload),//icon image
              label: Text('Upload Voice', style: TextStyle(fontFamily: "KhCon", fontSize: 16)),//text to show in button
              textColor: Colors.white,//button text and icon color.
              color: Colors.indigo,//button background color
              onPressed: () {},
            ),

          ],
        ),
      )
    );
  }

}