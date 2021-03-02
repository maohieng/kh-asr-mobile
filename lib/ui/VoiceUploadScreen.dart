import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:typed_data' show Uint8List;

class VoiceUploadScreen extends StatefulWidget {
  @override
  _VoiceUploadScreenState createState() => _VoiceUploadScreenState();
}

const _SERVER_URL = 'ws://103.16.63.37:9002/api/asr/';
const int _SAMPLE_RATE = 16000;

///
const int tBlockSize = 4000;

class _VoiceUploadScreenState extends State<VoiceUploadScreen> {
  // ui
  var _textController = new TextEditingController();

  // web socket
  IOWebSocketChannel _websocket;

  String _beforeResult = '';
  String _previousResult = '';
  File _audioFile;
  FilePickerResult _pathFile;
  String _fileName = '';
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  @override
  void initState() {
    super.initState();
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mPlayer.closeAudioSession();
    _mPlayer = null;
    if (_websocket != null) {
      _websocket.sink?.close();
    }
  }

  Future play() async {
    await _mPlayer.startPlayerFromStream(
        codec: Codec.pcm16, numChannels: 1, sampleRate: _SAMPLE_RATE);
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer.stopPlayer();
    }
  }

  // -------  Here is the code to playback a remote file -----------------------

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

  Future<void> _sendMessage(String filePath) async {
    _beforeResult = '';
    _previousResult = '';
    final bufferedStream =
        bufferChunkedStream(File(filePath).openRead(), bufferSize: tBlockSize);
    final iterator = ChunkedStreamIterator(bufferedStream);
    // While the reader has a next byte
    await play();
    log("voice: start");
    startWebSocket();
    var databyte;
    while (true) {
      // read one byte
      var data = await iterator.read(tBlockSize);
      if (data.isEmpty) {
        print('End of file reached');
        break;
      }
      print('next byte: ${data[0]}');
      databyte = Uint8List.fromList(data).buffer.asUint8List();
      await _mPlayer.feedFromStream(databyte);
      _websocket.sink.add(data);
    }
    await stopPlayer();
  }

  void openFilePicker() async {
    _pathFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );

    if (_pathFile != null) {
      _audioFile = File(_pathFile.files.single.path);
      _sendMessage(_audioFile.path);
    } else {
      // User canceled the picker
    }
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
                              hintText: '',
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
                              Icons.attach_file,
                              color: Colors.indigo,
                            ),
                            Text(
                              _fileName,
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
                              IconButton(
                                icon: Icon(Icons.upload_file),
                                color: Colors.indigo,
                                onPressed: openFilePicker,
                              ),
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
        Image.asset(
          'assets/images/upload2.png',
          fit: BoxFit.contain,
          height: 62,
          width: 62,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text("Testing"),
        ),
      ],
    );
  }
}
