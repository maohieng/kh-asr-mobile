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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                text:
                    'Khmer Automatic Speech Recognition – Khmer ASR គឺជាប្រព័ន្ធដែលប្រើប្រាស់បច្ចេកវិទ្យាឌីជីថលក្នុងការបំលែងសំឡេងនិយាយជាភាសាខ្មែរទៅជាអត្ថបទសរសេរដោយស្វ័យប្រវត្តិ។',
                style: TextStyle(height: 2, color: Colors.black, fontSize: 15)),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
                text:
                    'ប្រព័ន្ធនេះត្រូវបានបង្កើតឡើងដោយការប្រើប្រាស់វិធីសាស្រ្តរួមបញ្ចូលគ្នារវាង Statistical Learning និង Deep Learning ដែលជាវិធីសាស្រ្តថ្មី​សម្រាប់បង្កើតប្រព័ន្ធស្វ័យប្រវត្តិកម្មបំលែងសំឡេងនិយាយទៅជាអត្ថបទសរសេរសម្រាប់ភាសាដែលមានលក្ខណៈស្មុគស្មាញនិងមានទិន្នន័យជាទម្រង់ឌីជីថលតិច។',
                style: TextStyle(height: 2, color: Colors.black, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
