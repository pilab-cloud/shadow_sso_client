import 'package:grpc/grpc.dart';

import 'endpoint.dart';

List<Endpoint> endpoints = [
  Endpoint('127.0.0.1', 5000, secure: false, timeout: 2),
  Endpoint('vm1.pilab.dev', 8443, secure: true, timeout: 5),
];

ClientChannel createChannel(String host, int port, bool secure,
    {List<int>? certificates,
    String? authority,
    String? password,
    int timeout = 5}) {
  return ClientChannel(host, // Your IP here or localhost
      port: port,
      options: ChannelOptions(
        credentials: secure
            ? ChannelCredentials.secure(
                certificates: certificates,
                authority: authority,
                password: password)
            : const ChannelCredentials.insecure(),
        idleTimeout: const Duration(seconds: 1),
      ));
}
