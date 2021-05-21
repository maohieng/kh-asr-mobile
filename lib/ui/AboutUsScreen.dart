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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            //
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.all(0),
                  //   child: Image(
                  //       image: AssetImage('assets/images/logo_app_final.png'),
                  //       alignment: Alignment.center,
                  //       height: 150),
                  // ),
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            'ប្រព័ន្ធស្វ័យប្រវតិ្តកម្មបំលែងសំឡេងនិយាយភាសាខ្មែរទៅជាអត្ថបទសរសេរ (Khmer Automatic Speech Recognition – Khmer ASR) គឺជាប្រព័ន្ធដែលប្រើប្រាស់បច្ចេកវិទ្យាបញ្ញាសិប្បនិមិត្ត (Artificial Intelligence) ក្នុងការបំលែងសំឡេងនិយាយនិងឯកសារជាសំលេងជាភាសាខ្មែរ ទៅជាអត្ថបទសរសេរដោយស្វ័យប្រវត្តិ។',
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
                            'ប្រព័ន្ធនេះត្រូវបានបង្កើតឡើងទាំងស្រុង ដោយក្រុមអ្នកស្រាវជ្រាវវ័យក្មេង របស់បណ្ឌិត្យសភាបច្ចេកវិទ្យាឌីជីថលកម្ពុជា (CADT) នៃក្រសូងប្រៃសណីយ៏ និងទូរគមនាគមន៏ ដោយការប្រើប្រាស់វិធីសាស្រ្តរួមបញ្ចូលគ្នារវាង Statistical Learning និង Deep Learning ដែលជាវិធីសាស្រ្តថ្មី​ សម្រាប់បង្កើតប្រព័ន្ធស្វ័យប្រវត្តិកម្មបំលែងសំឡេងនិយាយទៅជាអត្ថបទសរសេរសម្រាប់ភាសា ដែលមានលក្ខណៈស្មុគស្មាញនិងមានទិន្នន័យតិចក្នុងទម្រង់ឌីជីថល។',
                        style: TextStyle(
                            height: 2, color: Colors.black, fontSize: 15)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text: "គាំទ្រនិងរក្សាសិទ្ធគ្រប់យ៉ាងដោយ",
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                            fontSize: 14)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage('assets/images/logo_mptc.png'),
                        alignment: Alignment.center,
                        height: 90,
                      ),
                      Padding(padding: const EdgeInsets.all(15)),
                      Image(
                        image: AssetImage('assets/images/logo_cadt.png'),
                        alignment: Alignment.center,
                        height: 90,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                  ),
                  // RichText(
                  //   textAlign: TextAlign.justify,
                  //   text: TextSpan(
                  //       text: "គាំទ្រនិងរក្សាសិទ្ធគ្រប់យ៉ាងដោយ",
                  //       style: TextStyle(
                  //           height: 1.5, color: Colors.black, fontSize: 14)),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
