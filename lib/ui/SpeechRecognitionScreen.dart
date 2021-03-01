import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/widget/RipplesAnimation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechRecognitionScreen extends StatefulWidget {
  @override
  _SpeechRecognitionScreenState createState() =>
      _SpeechRecognitionScreenState();
}

// const _SERVER_URL = 'ws://103.16.63.37:9002/api/asr/';
const _SERVER_URL = 'ws://172.23.21.61:9000/api/asr/';
const int _SAMPLE_RATE = 16000;

typedef _Fn = void Function();

class _SpeechRecognitionScreenState extends State<SpeechRecognitionScreen> {
  // ui
  var _textController = new TextEditingController();

  // recorder
  bool _recorderIsInited = false;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamSubscription _recordingDataSubscription;

  // web socket
  IOWebSocketChannel _websocket;

  String _beforeResult = '';
  String _previousResult = '';

  @override
  void initState() {
    super.initState();
    _openRecorder();
  }

  @override
  void dispose() {
    stopRecorder();
    _recorder.closeAudioSession();
    _recorder = null;

    _websocket.sink?.close();
    super.dispose();
  }

  Future<void> startWebSocket() async {
    _websocket = IOWebSocketChannel.connect(Uri.parse(_SERVER_URL));

    _websocket.stream.listen((message) {
      if (message == '') {
        if (_beforeResult != '') {
          _previousResult += _beforeResult + ' ';
        }
      } else {
        _textController.text = _previousResult + message;
        setState(() {});
      }

      _beforeResult = message;
    });
  }

  Future<void> stopWebSocket() async {
    await _websocket.sink.close();
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder.openAudioSession();
    setState(() {
      _recorderIsInited = true;
    });
  }

  Future<void> stopRecorder() async {
    await _recorder.stopRecorder();

    if (_recordingDataSubscription != null) {
      await _recordingDataSubscription.cancel();
      _recordingDataSubscription = null;
      // stop web socket
      stopWebSocket();
    }
  }

  Future<void> record() async {
    assert(_recorderIsInited);

    // start web socket
    startWebSocket();

    var recordingDataController = StreamController<Food>();

    _recordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        _websocket.sink.add(buffer.data);
      }
    });

    await _recorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: _SAMPLE_RATE,
    );

    setState(() {});
  }

  _Fn getRecorderFn() {
    if (!_recorderIsInited) {
      return null;
    }
    return _recorder.isStopped
        ? record
        : () {
            stopRecorder().then((value) => setState(() {}));
          };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, bottom: 10, right: 5, left: 5),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Container(
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: _textController,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.indigo,
                            ),
                            Text(
                              "00:00:00",
                              style: TextStyle(color: Colors.indigo),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ButtonBar(
                            //alignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.copy),
                                color: Colors.indigo,
                                onPressed: () {},
                              ),
                              // IconButton(
                              //   icon: Icon(Icons.edit),
                              //   color: Colors.indigo,
                              //   onPressed: () {},
                              // ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: getRecorderFn(),
          child: Container(
            height: 90,
            child: _recorder.isRecording == false
                ? Image.asset(
                    'assets/images/microphone_2_2.png',
                    fit: BoxFit.contain,
                    height: 62,
                    width: 62,
                  )
                : RipplesAnimation(
                    child: null,
                  ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(""),
        ),
      ],
    );
  }
}
