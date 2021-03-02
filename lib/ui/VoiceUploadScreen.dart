import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';

class VoiceUploadScreen extends StatefulWidget {
  @override
  _VoiceUploadScreenState createState() => _VoiceUploadScreenState();
}

const _SERVER_URL = 'ws://103.16.63.37:9002/api/asr/';
const int _SAMPLE_RATE = 16000;

class _VoiceUploadScreenState extends State<VoiceUploadScreen> {
  // ui
  var _textController = new TextEditingController();

  // web socket
  IOWebSocketChannel _websocket;

  String _beforeResult = '';
  String _previousResult = '';
  File _audioFile;
  FilePickerResult _path_file;
  String _file_name = '';
  FlutterSoundPlayer myPlayer = FlutterSoundPlayer();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (_websocket != null) {
      _websocket.sink?.close();
    }
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

  Future<void> _sendMessage(String filePath) async {
    final reader = ChunkedStreamIterator(File(filePath).openRead());
    // While the reader has a next byte
    startWebSocket();
    while (true) {
      // read one byte
      var data = await reader.read(4000);
      if (data.length == 0) {
        print('End of file reached');
        break;
      }
      print('next byte: ${data[0]}');
      _websocket.sink.add(data);
    }
    // stopWebSocket();
  }

  void openFilePicker() async {
    _path_file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );
    if (_path_file != null) {
      _audioFile = File(_path_file.files.single.path);
      _file_name = _path_file.files.single.name;
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
                              _file_name,
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
                              // IconButton(
                              //   icon: Icon(Icons.copy),
                              //   color: Colors.indigo,
                              //   onPressed: () {},
                              // ),
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
          child: Text(""),
        ),
      ],
    );
  }
}
