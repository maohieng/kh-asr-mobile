import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:typed_data' show Uint8List;
import 'package:khmerasr/ui/widget/RipplesAnimation.dart';
import 'package:clipboard/clipboard.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/Common.dart';
import '../utils/Toast.dart';
import '../utils/FFmpeg.dart';
import '../utils/Dialogs.dart';

class VoiceUploadScreen extends StatefulWidget {
  @override
  _VoiceUploadScreenState createState() => _VoiceUploadScreenState();
}

///
const int tBlockSize = 4000;

class _VoiceUploadScreenState extends State<VoiceUploadScreen> {
  // ui
  TextEditingController _textController = new TextEditingController();
  ScrollController _scrollController = ScrollController();

  // web socket
  IOWebSocketChannel _webSocketChannel;
  String _beforeResult = '';
  String _previousResult = '';

  // player
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();

  // file
  String _audioFilePath;
  String _audioFilename = '';

  GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void initState() {
    super.initState();
    initPermission();

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

  initPermission() async {
    final status = await Permission.storage.request();
    return status != PermissionStatus.granted;
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
        if (message.split(' ').length == 1 && message != _beforeResult) {
          _previousResult += _beforeResult + ' ';
        }

        _textController.text = _previousResult + message;
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
    if (_audioFilePath != null) {
      if (_mPlayer.isPlaying == true) {
        await stopPlayer().then((value) => setState(() {}));
      } else {
        await _processStreaming(_audioFilePath)
            .then((value) => setState(() {}));
      }
    } else {
      showWarningToast(context, "សូមជ្រើសរើសឯកសារសំឡេង!");
    }
  }

  Future<void> _processStreaming(String filePath) async {
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

    await initPlayer();

    _beforeResult = '';
    _previousResult = '';

    final bufferedStream = bufferChunkedStream(File(filePath).openRead());
    final iterator = ChunkedStreamIterator(bufferedStream);

    var data;
    while (_mPlayer.isPlaying) {
      data = await iterator.read(tBlockSize);
      if (data.isEmpty) {
        break;
      }
      await _mPlayer.feedFromStream(Uint8List.fromList(data));
      _webSocketChannel.sink.add(data);
    }

    await stopPlayer();
    await stopWebSocket();
  }

  void openFilePicker() async {
    var filePicker;
    try {
      filePicker = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['wav', 'mp3', 'ogg', 'm4a'],
      );
    } on Exception catch (e) {
      // user not allow file permission
      print(e);
      return;
    }

    if (filePicker != null) {
      var selectFile = filePicker.files.single;

      _audioFilePath = selectFile.path;
      _audioFilename = selectFile.name;
      setState(() {});

      Map audioInfo = await getMediaInfo(selectFile.path);
      var format = audioInfo['format_name'];
      var sampleRate = audioInfo['sample_rate'];
      var channel = audioInfo['nb_streams'];

      if (format != 'wav' || sampleRate != '16000' || channel != 1) {
        final tmpFile = File(await getTmpDirPath() + '/audio.wav');
        if (await tmpFile.exists() == true) {
          await tmpFile.delete();
        }

        Dialogs.showLoadingDialog(context, _keyLoader, "កំពុងដំណើរការ....");
        await preprocessAudio(selectFile.path, tmpFile.path);
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        _audioFilePath = tmpFile.path;
      }

      showToast(context, "ឯកសារសំឡេងត្រូវបានជ្រើសរើស!");
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
                          controller: _scrollController,
                          child: TextField(
                            controller: _textController,
                            maxLines: null,
                            textAlign: TextAlign.justify,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'សូមបញ្ចូលឯកសារសំឡេង',
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
                            Container(
                                constraints: BoxConstraints(maxWidth: 150),
                                child: Text(_audioFilename,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: TextStyle(color: Colors.indigo))),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ButtonBar(
                            //alignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: 'ចម្លងអត្ថបទ',
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
                                tooltip: 'បញ្ចូលឯកសារ',
                                icon: Icon(Icons.upload_file),
                                color: Colors.indigo,
                                onPressed: _mPlayer.isPlaying == false
                                    ? openFilePicker
                                    : null,
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
                    'assets/images/microphone_2_pro.png',
                    fit: BoxFit.contain,
                    height: 62,
                    width: 62,
                  )
                : RipplesAnimation(
                    color: Colors.red, icon: Icons.not_interested, child: null),
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
