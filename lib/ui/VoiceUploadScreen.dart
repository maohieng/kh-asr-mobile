import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:typed_data' show Uint8List;
import 'package:khmerasr/ui/widget/RipplesAnimation.dart';
import 'package:clipboard/clipboard.dart';
import '../utils/Common.dart';
import '../utils/Toast.dart';

class VoiceUploadScreen extends StatefulWidget {
  @override
  _VoiceUploadScreenState createState() => _VoiceUploadScreenState();
}

///
const int tBlockSize = 4000;

class _VoiceUploadScreenState extends State<VoiceUploadScreen> {
  // ui
  var _textController = new TextEditingController();

  // web socket
  IOWebSocketChannel _webSocketChannel;
  String _beforeResult = '';
  String _previousResult = '';

  // player
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();

  // file
  File _audioFile;
  FilePickerResult _pathFile;
  String _fileName = '';

  @override
  void initState() {
    super.initState();
    _mPlayer.openAudioSession().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    if (_webSocketChannel != null) {
      _webSocketChannel.sink?.close();
    }

    super.dispose();
  }

  Future initPlayer() async {
    await _mPlayer.startPlayerFromStream(
        codec: Codec.pcm16, numChannels: 1, sampleRate: SAMPLE_RATE);
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer.stopPlayer();
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

  Future<void> playStreaming() async {
    if (_pathFile != null) {
      _audioFile = File(_pathFile.files.single.path);
      if (_mPlayer.isPlaying == true) {
        stopPlayer().then((value) => setState(() {}));
        stopWebSocket();
      } else {
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
        _textController.text = "";
        _sendMessage(_audioFile.path).then((value) => setState(() {}));
      }
    } else {
      showWarningToast(context, "សូមមេត្តាជ្រើសរើសឯកសារសម្លេងជាមុន!");
    }
  }

  Future<void> _sendMessage(String filePath) async {
    _beforeResult = '';
    _previousResult = '';

    // init player
    await initPlayer();

    final bufferedStream = bufferChunkedStream(File(filePath).openRead());
    final iterator = ChunkedStreamIterator(bufferedStream);

    var data;
    while (true) {
      data = await iterator.read(tBlockSize);
      if (data.isEmpty) {
        print('End of file reached');
        break;
      }
      await _mPlayer.feedFromStream(Uint8List.fromList(data));
      _webSocketChannel.sink.add(data);
    }

    // stop player
    await stopPlayer();
  }

  void openFilePicker() async {
    _pathFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['wav'],
    );
    _fileName = _pathFile.files.single.name;
    _textController.text = "";
    if (_pathFile != null) {
      showToast(context, "ឯកសារសម្លេងត្រូវបានជ្រើសរើស!");
    } else {
      showToast(context, "ឯកសារសម្លេងមិនត្រឹមត្រូវ!");
    }
    setState(() {});
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
                            textAlign: TextAlign.justify,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'សូមបញ្ចូលឯកសារសំលេង',
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
        // Image.asset(
        //   'assets/images/upload2.png',
        //   fit: BoxFit.contain,
        //   height: 62,
        //   width: 62,
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 2),
        //   child: Text("Testing"),
        // ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: playStreaming,
          child: Container(
            height: 90,
            child: _mPlayer.isPlaying == false
                ? Image.asset(
                    'assets/images/microphone_2_3.png',
                    fit: BoxFit.contain,
                    height: 62,
                    width: 62,
                  )
                : RipplesAnimation(
                    color: Colors.red, icon: Icons.audiotrack, child: null),
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
