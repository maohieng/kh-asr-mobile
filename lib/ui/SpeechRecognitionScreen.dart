import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/widget/RipplesAnimation.dart';
import 'package:niptict_asr_app/utils/HexColor.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class SpeechRecognitionScreen extends StatefulWidget {
  @override
  _SpeechRecognitionScreenState createState() =>
      _SpeechRecognitionScreenState();
}
// Change this URL to your own
const _SERVER_URL = 'wss://echo.websocket.org/';

class _SpeechRecognitionScreenState extends State<SpeechRecognitionScreen> {
  final channel = IOWebSocketChannel.connect(_SERVER_URL);
  var textController = new TextEditingController();
  RecorderStream _recorder = RecorderStream();
  PlayerStream _player = PlayerStream();

  List<Uint8List> _micChunks = [];
  bool _isRecording = false;
  bool _isPlaying = false;

  StreamSubscription _recorderStatus;
  StreamSubscription _playerStatus;
  StreamSubscription _audioStream;

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _playerStatus?.cancel();
    _audioStream?.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {

    //================= For streaming voice to Server ===================
    channel.stream.listen((event) async {
       //print(event);
      if (_isPlaying) _player.writeChunk(event);
    });

    _audioStream = _recorder.audioStream.listen((data) {
      channel.stream.listen((message) {
        channel.sink.add('received!');
        channel.sink.close(status.goingAway);
      });
    });

    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _audioStream = _recorder.audioStream.listen((data) {
      if (_isPlaying) {
        _player.writeChunk(data);
        // //print(data);
        print("SALY AAAA");
      } else {
        setState(() {
          textController.text = data.toString();
        });
        _micChunks.add(data);
         print(channel);
        //print(data);
      }
    });

    _playerStatus = _player.status.listen((status) {
      if (mounted)
        setState(() {
          _isPlaying = status == SoundStreamStatus.Playing;
          print(status);

        });
    });

    await Future.wait([
      _recorder.initialize(),
      _player.initialize(),
    ]);
  }

  void _play() async {
    await _player.start();

    if (_micChunks.isNotEmpty) {
      for (var chunk in _micChunks) {
        await _player.writeChunk(chunk);
      }
      _micChunks.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/niptict.png',
                fit: BoxFit.contain,
                height: 42,
              ),
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('កម្មវិធីបំលែងពីសំលេងទៅជាអក្សរ',style: TextStyle(fontFamily: "KhMuol", fontSize: 14)))
            ],

          ),
          centerTitle: true,
          backgroundColor: HexColor('#0D47A1'),
          shadowColor: Colors.transparent,
        ),
        body:Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5,bottom: 30,right: 10,left: 10),
                child: Container(
                  constraints: BoxConstraints(maxHeight: 100),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: textController,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'សូមនិយាយជាភាសាខ្មែរ',
                      ),
                      style: TextStyle(fontFamily: "KhCon", fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),

            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap:_isRecording ? _recorder.stop : _recorder.start,
                child: Container(
                  height: 90,
                  child: _isRecording == false
                      ? Image.asset(
                      'assets/images/microphone_2_1.png',
                      fit: BoxFit.contain,
                      height: 62,
                      width: 62,
                      )   : RipplesAnimation(
                    child: null,
                  ),
                ),
                ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(""),
            ),
          ],
        ),
      ),
    );
  }
}
