import 'dart:io';

const SERVER_URL = 'ws://103.16.63.37:9002/api/asr/';
const int SAMPLE_RATE = 16000;

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var hours = (secs ~/ 3600).toString().padLeft(2, '0');
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  return "$hours:$minutes:$seconds";
}

Future<bool> checkInternetConnection() async {
  try {
    await InternetAddress.lookup('google.com');
  } on SocketException catch (_) {
    return false;
  }
  return true;
}
