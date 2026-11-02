import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';

import '_channel.dart' if (dart.library.html) '_channel_html.dart';

class Endpoint {
  final String host;
  final int port;
  final bool secure;
  final int timeout;

  Endpoint(
    this.host,
    this.port, {
    this.secure = false,
    this.timeout = 5,
  });
}

ClientChannel getChannel() {
  try {
    return createChannel(
      endpoints[0].host,
      endpoints[0].port,
      endpoints[0].secure,
      timeout: endpoints[0].timeout,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Failed to connect to first endpoint: $e');
      print('Trying second endpoint...');
    }

    return createChannel(
      endpoints[0].host,
      endpoints[0].port,
      endpoints[0].secure,
      timeout: endpoints[0].timeout,
    );
  }
}
