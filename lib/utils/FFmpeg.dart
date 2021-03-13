import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:flutter_ffmpeg/stream_information.dart';

Future<Map> getMediaInfo(String file) async {
  final FlutterFFprobe _flutterFFprobe = new FlutterFFprobe();
  MediaInformation info = await _flutterFFprobe.getMediaInformation(file);

  Map mediaInfo = info.getMediaProperties();
  if (info.getStreams() != null) {
    List<StreamInformation> streams = info.getStreams();
    if (streams.length > 0) {
      for (var stream in streams) {
        mediaInfo.addAll(stream.getAllProperties());
      }
    }
  }

  return mediaInfo;
}

Future<int> preprocessAudio(fileIn, fileOut) async {
  // framerate=16000, mono=1, silence padding=1s,1s
  String option =
      '-ar 16000 -ac 1 -af "adelay=1s:all=true" -af "apad=pad_dur=1"';
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  return await _flutterFFmpeg.execute("-i '$fileIn' $option $fileOut");
}
