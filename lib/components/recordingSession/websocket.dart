import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MyWebSocket {
  MyWebSocket(String channel) {
    try {
      this.channel = IOWebSocketChannel.connect(channel);
    } catch (e) {
      print('Connection exception $e');
    }
  }

  WebSocketChannel channel;

  Future<void> sendAudioFile(
      String exportedAudioData, int userID, String topic) async {
    final List<int> audioData = await processAudioFile(exportedAudioData);
    print(audioData.toString() + '\n'); // array of integers/bytes
    channel.sink.add(
      json.encode(
        {'audio_data': audioData, 'user_id': userID.toInt(), 'topic': topic},
      ),
    );
  }

  void sendFirstMessage(int userId) {
    channel.sink.add(
      json.encode(
        {'user_id': userId.toInt()},
      ),
    );
  }

  Future<List<int>> processAudioFile(String audioData) async {
    final File file = File(audioData);
    file.openRead();
    final Uint8List uint8list = file.readAsBytesSync();
    final List<int> fileBytes = uint8list.cast<int>();

    return fileBytes;
  }
}
