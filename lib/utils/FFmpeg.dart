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

Future<void> preprocessAudio(fileIn, fileOut) async {
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  await _flutterFFmpeg.execute("-i '$fileIn' -ar 16000 -ac 1 $fileOut");
}
