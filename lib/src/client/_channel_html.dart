import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

import 'endpoint.dart';
import 'transport/websocket_transport.dart';

final List<Endpoint> endpoints = [
  Endpoint('127.0.0.1', 8080, timeout: 2),
  Endpoint('vm1.pilab.dev', 8080, secure: true, timeout: 15),
];

// createChannel creates a new html client based websocket stream
ClientChannel createChannel(String host, int port, bool secure,
    {int timeout = 5}) {
  return _WebSocketClientChannel(
    host,
    port: port,
    options: ChannelOptions(
      connectionTimeout: Duration(seconds: timeout),
      credentials: secure
          ? const ChannelCredentials.secure()
          : const ChannelCredentials.insecure(),
    ),
  );
}

class _WebSocketClientChannel extends ClientChannel {
  // @override
  // final ChannelOptions options;

  final Object _host;

  _WebSocketClientChannel(this._host,
      {required super.port, required super.options})
      : assert(_host is InternetAddress || _host is String),
        super(_host);

  @override
  ClientConnection createConnection() {
    return WebSocketClientConnection(_host as String, port, options: options);
  }
}
