
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/SpeechRecognitionScreen.dart';

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
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SpeechRecognitionScreen()));
                },
                child: Text('ចាប់ផ្តើម', style: TextStyle(fontFamily: "KhCon", fontSize: 14)
                ),
                textColor: Colors.indigo,
                shape: RoundedRectangleBorder(side: BorderSide(
                    color: Colors.blue,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ],
        ),
      )
    );
  }

}