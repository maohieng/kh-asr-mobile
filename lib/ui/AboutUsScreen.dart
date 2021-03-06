import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      // margin: EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image(
              image: AssetImage('assets/images/logo_app.jpg'),
              alignment: Alignment.center,
              height: 100,
            ),
          ),
          Expanded(
            //
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            'Khmer Automatic Speech Recognition – Khmer ASR គឺជាប្រព័ន្ធដែលប្រើប្រាស់បច្ចេកវិទ្យាឌីជីថលក្នុងការបំលែងសំឡេងនិយាយជាភាសា ​ខ្មែរ​ទៅជាអត្ថបទសរសេរដោយស្វ័យប្រវត្តិ។',
                        style: TextStyle(
                            height: 2, color: Colors.black, fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            'ប្រព័ន្ធនេះត្រូវបានបង្កើតឡើងដោយការប្រើប្រាស់វិធីសាស្រ្តរួមបញ្ចូលគ្នារវាង Statistical Learning និង Deep Learning ដែលជាវិធីសាស្រ្តថ្មី​សម្រាប់បង្កើតប្រព័ន្ធស្វ័យប្រវត្តិកម្មបំលែងសំឡេងនិយាយទៅជាអត្ថបទសរសេរសម្រាប់ភាសាដែលមានលក្ខណៈស្មុគស្មាញនិងមានទិន្នន័យជាទម្រង់ឌីជីថលតិច។',
                        style: TextStyle(
                            height: 2, color: Colors.black, fontSize: 15)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            "This app is developed by Research and Development Team of National Institute of Posts Telecoms, and ICT (NIPTICT), under the support from Ministry of Posts and Telecommunications.This app is built by using digital technology to convert Khmer Speech into Automatic Text. It uses the combination of two approaches, Statistical Learning Approach and Deep Learning Approach.",
                        style: TextStyle(
                            height: 1.5, color: Colors.black, fontSize: 14)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text: "គាំទ្រដោយ / Support By",
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/logo_cadt.png'),
                        alignment: Alignment.center,
                        height: 100,
                      ),
                      Image(
                        image: AssetImage('assets/images/logo_mptc.png'),
                        alignment: Alignment.center,
                        height: 100,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text: "@រក្សាសិទ្ធគ្រប់យ៉ាង / @All Rights Reserved",
                        style: TextStyle(
                            height: 1.5, color: Colors.black, fontSize: 14)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
