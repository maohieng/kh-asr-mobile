import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:niptict_asr_app/ui/widget/RipplesAnimation.dart';
import 'package:niptict_asr_app/utils/HexColor.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class VoiceUploadScreen extends StatefulWidget {
  @override
  _VoiceUploadScreenState createState() =>
      _VoiceUploadScreenState();
}
// Change this URL to your own
const _SERVER_URL = 'ws://103.16.63.37:9002/api/asr/';
//ws://103.16.63.37:9002/api/asr/

class _VoiceUploadScreenState extends State<VoiceUploadScreen> {
  final channel = IOWebSocketChannel.connect(Uri.parse(_SERVER_URL));//IOWebSocketChannel.connect(_SERVER_URL);
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
    //var channel = IOWebSocketChannel.connect(_SERVER_URL);
    //================= For streaming voice to Server ===================
    channel.stream.listen((event) async {
       print(event);
      if (_isPlaying) _player.writeChunk(event);
    });

    _audioStream = _recorder.audioStream.listen((data) {
      channel.sink.add(data);

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
        //print(data);
      } else {
        setState(() {
          textController.text = data.toString();
        });
        _micChunks.add(data);
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


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 5,bottom: 10,right: 5,left: 5),
            child:Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: Container(
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Icon(Icons.attach_file,color: Colors.indigo,),
                            Text("TheVoiceNIPTICT.wav",style: TextStyle(color: Colors.indigo),),
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
                                onPressed: () {},
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
