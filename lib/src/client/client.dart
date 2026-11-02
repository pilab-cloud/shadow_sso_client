import 'package:grpc/grpc.dart';
import 'package:logger/logger.dart';
import 'package:shadow_sso_client/src/client/endpoint.dart';

import '../_generated/pilab/ssso/v1/ssso_service.pbgrpc.dart' as pb;

/// A client for the Shadow Single Sign-On service.
class ShadowSSOClient {
  late ClientChannel _channel;
  late final pb.AuthServiceClient _grpcClient;
  late final Logger _log;

  // Constructor params
  final Level logLevel;

  ShadowSSOClient({
    this.logLevel = Level.debug,
  }) {
    _log = Logger(
        printer: LogfmtPrinter(),
        // output: MultiOutput([
        //   ConsoleOutput(),
        //   FileOutput(
        //     file: File('shadow_sso_client.log'),
        //     overrideExisting: true,
        //   ),
        // ]),
        level: logLevel);

    _channel = getChannel();

    _grpcClient = pb.AuthServiceClient(
      _channel,
      options: CallOptions(
        timeout: const Duration(seconds: 5),
      ),
    );
  }

  _handleSuccessLogin(pb.AuthTokenResponse response) {
    _log.d('AccessToken: ${response.accessToken}');
    _log.d('RefreshToken: ${response.refreshToken}');
    _log.d('OfflineToken: ${response.offlineToken}');
  }

  Future<void> login(String username, String password) async {
    _log.i('Logging in with username: $username');

    // Create a login request
    final loginRequest = pb.LoginRequest(
      passwordAuth: pb.PasswordLoginRequest(
        username: username,
        password: password,
      ),
      scopes: ['offline_access'],
    );

    final result = await _grpcClient.login(loginRequest);

    switch (result.whichResponse()) {
      case pb.LoginResponse_Response.tokenResponse:
        _handleSuccessLogin(result.tokenResponse);
        break;
      case pb.LoginResponse_Response.errorResponse:
        _log.e('Login failed: ${result.errorResponse.toString()}');
        break;
      default:
        _log.i('Login failed: No result returned');
        break;
    }

    _log.i('Login completed');
  }

  Future<void> register(String email, String password) async {
    // Implement the register logic here
    // You can make API calls or perform any other necessary operations
    // Remember to handle any errors that may occur during the registration process
  }

  Future<void> logout() async {
    // Implement the logout logic here
    // You can make API calls or perform any other necessary operations
    // Remember to handle any errors that may occur during the logout process
  }

  void dispose() {
    _log.d('Destroying client');
    _channel.shutdown();
  }
}
