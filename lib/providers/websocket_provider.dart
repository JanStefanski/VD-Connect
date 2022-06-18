import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketProvider extends ChangeNotifier {
  late WebSocketChannel _channel;
  Stream get stream => _channel.stream.asBroadcastStream();
  bool _isConnected = false;
  get isConnected => _isConnected;

  void connect(url) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _isConnected = true;
    notifyListeners();
  }

  void send(message) {
    _channel.sink.add(message);
  }

  void close() {
    _isConnected = false;
    notifyListeners();
    _channel.sink.close();
  }

  void closeSilent() {
    _channel.sink.close();
  }

  void connectSilent(url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel.sink.add('32');
  }

  void refresh() {
    notifyListeners();
  }

}