import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:khmerasr/ui/widget/RipplesAnimation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:clipboard/clipboard.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import '../utils/Common.dart';
import '../utils/Connectivity.dart';
import '../utils/Toast.dart';

class SpeechRecognitionScreen extends StatefulWidget {
  @override
  _SpeechRecognitionScreenState createState() =>
      _SpeechRecognitionScreenState();
}

class _SpeechRecognitionScreenState extends State<SpeechRecognitionScreen>
    with WidgetsBindingObserver {
  // ui
  TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  Stopwatch _stopwatch = Stopwatch();

  // recorder
  bool _recorderIsInited = false;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamSubscription _recordingDataSubscription;

  // internet connectivity
  StreamSubscription<DataConnectionStatus> _dataConnectionSubscription;

  // web socket
  IOWebSocketChannel _webSocketChannel;

  String _beforeResult = '';
  String _previousResult = '';

  // set timer for record voice
  Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // _openRecorder();

    initConnectionSubscription();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (_recorder.isRecording) {
      stopRecorder();
    }

    _recorder.closeAudioSession();
    _recorder = null;

    _dataConnectionSubscription.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_recorder.isRecording) {
        stopRecorder();
      }
      _dataConnectionSubscription.cancel();
    } else if (state == AppLifecycleState.resumed) {
      initConnectionSubscription();
    }
  }

  Future<bool> startWebSocket() async {
    try {
      _webSocketChannel =
          IOWebSocketChannel(await WebSocket.connect(SERVER_URL));
    } catch (e) {
      return false;
    }

    _webSocketChannel.stream.listen((message) {
      Map valueMap = json.decode(message);

      String trans = valueMap['text'];
      if (trans != null) {
        _previousResult += _beforeResult + ' ';
      }

      trans = valueMap['partial'];
      if (trans != null && trans != '') {
        _textController.text = _previousResult + trans;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        setState(() {});
      }

      _beforeResult = trans;
    });

    return true;
  }

  Future<void> stopWebSocket() async {
    if (_webSocketChannel != null) {
      await _webSocketChannel.sink.close();
    }
  }

  Future<bool> _openRecorder() async {
    var status = await initPermission();
    if (status == true) {
      await _recorder.openAudioSession();
      setState(() {
        _recorderIsInited = true;
      });
    }
    return status;
  }

  Future<bool> initPermission() async {
    var status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  void initConnectionSubscription() {
    var connectionChecker = DataConnectionChecker();
    // check every 3 seconds
    connectionChecker.checkInterval = Duration(seconds: 3);

    _dataConnectionSubscription =
        connectionChecker.onStatusChange.listen((status) {
      if (status == DataConnectionStatus.disconnected) {
        if (_recorder.isRecording) {
          showErrorToast(context, '???????????????????????????????????????????????????????????????????????????!');
          stopRecorder();
        }
      }
    });
  }

  Future<void> stopRecorder() async {
    await _recorder.stopRecorder();
    await _recordingDataSubscription.cancel();
    _recordingDataSubscription = null;

    _stopwatch.stop();
    _timer.cancel();

    stopWebSocket();

    setState(() {});
  }

  Future<void> startRecorder() async {
    var status = await checkInternetConnection();
    if (status == false) {
      showErrorToast(context, '???????????????????????????????????????????????????????????????????????????!');
      return;
    }

    status = await startWebSocket();
    if (status == false) {
      showErrorToast(context, "??????????????????????????????????????????????????????????????????????????????????????????!");
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
    _timer = new Timer.periodic(new Duration(milliseconds: 500), (timer) {
      setState(() {});
    });

    await _recorder.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: SAMPLE_RATE,
    );

    setState(() {});
  }

  Future<void> getRecorderFn() async {
    if (_recorderIsInited == false) {
      var status = await _openRecorder();
      if (status == false) {
        return;
      }
    }
    _recorder.isStopped ? startRecorder() : stopRecorder();
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
                          controller: _scrollController,
                          child: TextField(
                            controller: _textController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '?????????????????????????????????????????????????????????',
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
                                tooltip: '?????????????????????????????????',
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

                                  showToast(context, "?????????????????????????????????????????????????????????");
                                },
                              ),
                              IconButton(
                                  tooltip: '???????????????????????????',
                                  icon: Icon(Icons.delete),
                                  color: Colors.indigo,
                                  onPressed: _recorder.isRecording
                                      ? null
                                      : () {
                                          _beforeResult = '';
                                          _previousResult = '';
                                          _textController.clear();
                                          _stopwatch.reset();

                                          setState(() {});

                                          showToast(
                                              context, "???????????????????????????????????????????????????");
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
          onTap: getRecorderFn,
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
