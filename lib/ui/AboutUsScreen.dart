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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image(
                        image: AssetImage('assets/images/logo_app.jpg'),
                        alignment: Alignment.center,
                        height: 100),
                  ),
                  RichText(
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                        text:
                            'Khmer Automatic Speech Recognition – Khmer ASR គឺជាប្រព័ន្ធដែលប្រើប្រាស់បច្ចេកវិទ្យាឌីជីថលក្នុងការបំលែងសំឡេងនិយាយជាភាសា​ខ្មែរ​ទៅជាអត្ថបទសរសេរដោយស្វ័យប្រវត្តិ។',
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
                            'ប្រព័ន្ធបច្ចេកវិទ្យានេះត្រូវបានបង្កើតឡើងដោយការប្រើប្រាស់វិធីសាស្រ្តរួមបញ្ចូលគ្នារវាង Statistical Learning និង Deep Learning ដែលជាវិធីសាស្រ្តថ្មី​សម្រាប់បង្កើតប្រព័ន្ធស្វ័យប្រវត្តិកម្មបំលែងសំឡេងនិយាយទៅជាអត្ថបទសរសេរសម្រាប់ភាសាដែលមានលក្ខណៈស្មុគស្មាញនិងមានទិន្នន័យជាទម្រង់ឌីជីថលតិច។',
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
                            "សូមបញ្ជាក់ថាប្រព័ន្ធបំលែងសំឡេងនិយាយទៅជាអត្ថបទសរសេរ ត្រូវបានប្រើប្រាស់ទូលំទូលាយសម្រាប់ភាសាដែលមានទិន្នន័យជាទម្រង់ឌីជីថលច្រើន ដូចជាភាសាអង់គ្លេស បារាំង អេស៉្បាញ និងចិនជាដើម។ ដោយឡែក សម្រាប់ភាសាខ្មែរ មានតែក្រុមហ៊ុន Google មួយប៉ុណ្ណោះដែលផ្តល់សេវាបំលែងសំឡេងនិយាយជាភាសាខ្មែរទៅជាអត្ថបទសរសេរ ដោយសារក្រុមហ៊ុននេះមានទិន្នន័យឌីជីថលជាភាសាខ្មែរច្រើន។ ប៉ុន្តែប្រព័ន្ធបច្ចេកវិទ្យាភាសារបស់ក្រុមហ៊ុន Google នេះជាប្រព័ន្ធបិទ និងតម្រូវឱ្យមានការបង់កម្រៃសេវាក្នុងការទាញយក ឬការប្រើប្រាស់ Source Code ។ ម៉្យាងវិញទៀត យើងមិនមែនជាម្ចាស់ និងពុំមានលទ្ធភាពកែច្នៃប្រព័ន្ធបច្ចេកវិទ្យាភាសារបស់ក្រុមហ៊ុន Google នេះទេ ។",
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
                            "ប្រព័ន្ធបច្ចេកវិទ្យា “Khmer ASR” ត្រូវបានស្រាវជ្រាវនិងអភិវឌ្ឍន៍ឡើងដោយក្រុមអ្នកស្រាវជ្រាវរបស់បណ្ឌិត្យសភាបច្ចេកវិទ្យាឌីជីថលកម្ពុជា (អតីតវិទ្យាស្ថានជាតិប្រៃសណីយ៍ ទូរគមនាគមន៍, បច្ចេកវិទ្យាគមនាគមន៍ និងព័ត៌មាន) ក្នុងគោលបំណងដើម្បីឱ្យយើងអាចគ្រប់គ្រងដោយផ្ទាល់ និងមានលទ្ធភាពធ្វើការកែប្រែ, ធ្វើបច្ចុប្បន្នភាព, ឬបំពាក់បន្ថែមនូវប្រព័ន្ធ ឬបច្ចេកវិទ្យាផ្សេងទៀត ដើម្បីធ្វើការប្រើប្រាស់តាមតម្រូវការជាក់ស្តែងចាំបាច់នានា ។",
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
