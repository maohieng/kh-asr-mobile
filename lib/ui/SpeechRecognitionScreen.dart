import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:niptict_asr_app/ui/widget/RipplesAnimation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:clipboard/clipboard.dart';
import '../utils/Common.dart';
import '../utils/Toast.dart';

class SpeechRecognitionScreen extends StatefulWidget {
  @override
  _SpeechRecognitionScreenState createState() =>
      _SpeechRecognitionScreenState();
}

typedef _Fn = void Function();

class _SpeechRecognitionScreenState extends State<SpeechRecognitionScreen> {
  // ui
  var _textController = new TextEditingController();
  Stopwatch _stopwatch = Stopwatch();

  // recorder
  bool _recorderIsInited = false;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamSubscription _recordingDataSubscription;

  // web socket
  IOWebSocketChannel _webSocketChannel;

  String _beforeResult = '';
  String _previousResult = '';

  // set timer for record voice
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _openRecorder();
    _timer = new Timer.periodic(new Duration(milliseconds: 900), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    stopRecorder();
    _timer.cancel();
    _recorder.closeAudioSession();
    _recorder = null;

    if (_webSocketChannel != null) {
      _webSocketChannel.sink?.close();
    }
    super.dispose();
  }

  Future<bool> startWebSocket() async {
    try {
      _webSocketChannel =
          IOWebSocketChannel(await WebSocket.connect(SERVER_URL));
    } catch (e) {
      return false;
    }

    _webSocketChannel.stream.listen((message) {
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

    return true;
  }

  Future<void> stopWebSocket() async {
    await _webSocketChannel.sink.close();
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
      _stopwatch.stop();
      // stop web socket
      stopWebSocket();
    }
  }

  Future<void> record() async {
    assert(_recorderIsInited);

    var status = await checkInternetConnection();
    if (status == false) {
      showErrorToast(context, 'មិនមានការតភ្ជាប់អ៊ីនធឺណិតទេ!');
      return;
    }

    status = await startWebSocket();
    if (status == false) {
      showErrorToast(context, "មានបញ្ហាតភ្ជាប់ទៅកាន់ម៉ាស៊ីនមេ!");
      return;
    }

    var recordingDataController = StreamController<Food>();

    _recordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
      if (buffer is FoodData) {
        _webSocketChannel.sink.add(buffer.data);
      }
    });

    _stopwatch.start();

    await _recorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: SAMPLE_RATE,
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
                              formatTime(_stopwatch.elapsedMilliseconds),
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
                                onPressed: () {
                                  if (_textController.text.trim() == "") {
                                    print('enter text');
                                  } else {
                                    print(_textController.text);
                                    FlutterClipboard.copy(_textController.text)
                                        .then((value) => print('copied'));
                                  }

                                  showToast(context, "អត្ថបទត្រូវបានចម្លង");
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.indigo,
                                  onPressed: () {
                                    _beforeResult = '';
                                    _previousResult = '';
                                    _textController.clear();
                                    _stopwatch.reset();

                                    showToast(context, "អត្ថបទត្រូវបានលុប");
                                  }),
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
