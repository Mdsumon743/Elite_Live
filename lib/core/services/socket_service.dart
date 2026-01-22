import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class WebSocketClientService extends GetxService {
  final RxBool isConnected = false.obs;
  final RxBool isConnecting = false.obs;
  final RxString connectionError = ''.obs;

  WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  String? _socketUrl;
  String? _authToken;
  bool _isReconnecting = false;
  bool _isManualDisconnect = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const int _connectionTimeout = 15; // seconds

  Function(String)? onMessageRecived;
  Function(Map<String, dynamic>)? onContributionRequest;
  Function(Map<String, dynamic>)? onCoHostJoined;
  Function(Map<String, dynamic>)? onCoHostLeft;
  Function(Map<String, dynamic>)? onHostTransferred;
  Function(Map<String, dynamic>)? onHostLeft;
  Function(Map<String, dynamic>)? onBadWordWarning;
  Function(Map<String, dynamic>)? onUserBanned;

  static WebSocketClientService get to => Get.find();

  Future<void> connect(String socketUrl, String authToken) async {
    if (isConnecting.value) {
      log("⚠️ Connection already in progress");
      return;
    }

    _socketUrl = socketUrl;
    _authToken = authToken;
    _isManualDisconnect = false;
    isConnecting.value = true;
    connectionError.value = '';

    try {
      await _socket?.close();
      _reconnectTimer?.cancel();
      _pingTimer?.cancel();

      log("🔌 Connecting to $socketUrl");
      log("🔑 Auth token: ${authToken.substring(0, 20)}...");

      // Validate URL format
      final uri = Uri.parse(socketUrl);
      if (!uri.scheme.startsWith('ws')) {
        throw Exception('Invalid WebSocket URL scheme: ${uri.scheme}');
      }

      // Create HttpClient with SSL bypass for development
      final httpClient = HttpClient();

      if (kDebugMode) {
        httpClient.badCertificateCallback = (cert, host, port) {
          log("⚠️ Bypassing SSL verification for $host:$port (DEBUG MODE)");
          return true;
        };
      }

      // Set connection timeout
      httpClient.connectionTimeout = Duration(seconds: _connectionTimeout);

      try {
        // Attempt WebSocket connection
        _socket = await WebSocket.connect(
          socketUrl,
          headers: {
            'x-token': authToken,
            'Connection': 'Upgrade',
            'Upgrade': 'websocket',
          },
          customClient: httpClient,
        ).timeout(
          Duration(seconds: _connectionTimeout),
          onTimeout: () {
            throw TimeoutException(
                'Connection timeout after $_connectionTimeout seconds. Server may be down or unreachable.'
            );
          },
        );

        log("✅ WebSocket connected successfully");
        isConnected.value = true;
        isConnecting.value = false;
        connectionError.value = '';
        _reconnectAttempts = 0;

        _startPingTimer();

        _socket?.listen(
              (message) {
            log("📨 Received: $message");
            _handleIncomingMessage(message);
            onMessageRecived?.call(message);
          },
          onDone: () {
            isConnected.value = false;
            isConnecting.value = false;
            log("🔌 Socket closed");
            _pingTimer?.cancel();
            if (!_isManualDisconnect) _handleDisconnect();
          },
          onError: (e) {
            isConnected.value = false;
            isConnecting.value = false;
            log("❌ Socket error: $e");
            connectionError.value = e.toString();
            _pingTimer?.cancel();
            if (!_isManualDisconnect) _handleDisconnect();
          },
          cancelOnError: false,
        );
      } on WebSocketException catch (e) {
        log("❌ WebSocket Exception: $e");

        // Parse error message for better diagnostics
        if (e.message.contains('502')) {
          connectionError.value = 'Server unavailable (502). The WebSocket server may be down or not properly configured.';
          log("💡 Tip: Check if the WebSocket server is running at $socketUrl");
          log("💡 Tip: Verify the server supports WebSocket upgrade protocol");
          log("💡 Tip: Check if there's a reverse proxy (nginx/apache) blocking WebSocket connections");
        } else if (e.message.contains('401')) {
          connectionError.value = 'Authentication failed (401). Invalid or expired token.';
          log("💡 Tip: Verify the x-token header is correct");
        } else if (e.message.contains('403')) {
          connectionError.value = 'Access forbidden (403). Token may not have required permissions.';
        } else if (e.message.contains('404')) {
          connectionError.value = 'WebSocket endpoint not found (404). Check the URL path.';
          log("💡 Tip: Verify the WebSocket endpoint path on the server");
        } else {
          connectionError.value = 'WebSocket connection failed: ${e.message}';
        }

        rethrow;
      } on SocketException catch (e) {
        log("❌ Socket Exception: $e");
        connectionError.value = 'Network error. Check your internet connection.';
        log("💡 Tip: Verify internet connectivity");
        log("💡 Tip: Check if the server hostname resolves: $uri");
        rethrow;
      } on TimeoutException catch (e) {
        log("❌ Timeout Exception: $e");
        connectionError.value = 'Connection timeout. Server not responding.';
        log("💡 Tip: Server may be offline or unreachable");
        rethrow;
      }
    } catch (e) {
      isConnected.value = false;
      isConnecting.value = false;
      log("❌ Connection error: $e");

      if (connectionError.value.isEmpty) {
        connectionError.value = e.toString();
      }

      if (!_isManualDisconnect) {
        _handleDisconnect();
      }

      rethrow;
    }
  }

  void _handleIncomingMessage(String message) {
    try {
      final decoded = jsonDecode(message);
      final messageType = decoded['type'];

      log("🎯 Processing message type: $messageType");

      switch (messageType) {
        case 'contribution-request':
          log("🎯 Received contribution request");
          onContributionRequest?.call(decoded);
          break;

        case 'cohost-joined':
          log("✅ Co-host joined notification");
          onCoHostJoined?.call(decoded);
          break;

        case 'cohost-left':
          log("❌ Co-host left notification");
          onCoHostLeft?.call(decoded);
          break;

        case 'host-transferred':
          log("🔄 Host transferred notification");
          onHostTransferred?.call(decoded);
          break;

        case 'accept-contribution':
          log("✅ Contribution accepted");
          break;

        case 'reject-contribution':
          log("❌ Contribution rejected");
          break;

        case 'bad-word-warning':
          log("⚠️ Bad word warning received");
          onBadWordWarning?.call(decoded);
          break;

        case 'banned':
          log("🚫 User banned notification");
          onUserBanned?.call(decoded);
          break;

        case 'pong':
          log("🏓 Pong received");
          break;

        case 'error':
          log("❌ Server error: ${decoded['message']}");
          break;

        default:
          log("📨 Unknown message type: $messageType");
      }
    } catch (e) {
      log("❌ Error processing incoming message: $e");
    }
  }

  void _startPingTimer() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (isConnected.value) {
        try {
          sendMessage({'type': 'ping'});
        } catch (e) {
          log("❌ Ping failed: $e");
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _handleDisconnect() {
    if (_isReconnecting) return;
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      log("❌ Max reconnection attempts reached");
      log("💡 Please check server status and try again manually");
      return;
    }

    _isReconnecting = true;
    _reconnectAttempts++;

    final delay = Duration(seconds: math.min(math.pow(2, _reconnectAttempts).toInt(), 30));
    log("🔄 Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)...");

    _reconnectTimer = Timer(delay, () {
      _isReconnecting = false;
      if (_socketUrl != null && _authToken != null && !_isManualDisconnect) {
        connect(_socketUrl!, _authToken!).catchError((e) {
          log("❌ Reconnection failed: $e");
        });
      }
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    if (!isConnected.value) {
      log("❌ Cannot send: WebSocket not connected");
      throw WebSocketException("WebSocket is not connected");
    }

    try {
      final jsonMessage = jsonEncode(message);
      _socket?.add(jsonMessage);
      log("📤 Sent: $jsonMessage");
    } catch (e) {
      log("❌ Send error: $e");
      rethrow;
    }
  }

  void disconnect() {
    _isManualDisconnect = true;
    _reconnectAttempts = 0;
    _reconnectTimer?.cancel();
    _pingTimer?.cancel();
    _socket?.close();
    _socket = null;
    isConnected.value = false;
    isConnecting.value = false;
    connectionError.value = '';
    log("🔌 Disconnected manually");
  }

  // Reset connection state for manual retry
  void resetConnectionState() {
    _reconnectAttempts = 0;
    connectionError.value = '';
    log("🔄 Connection state reset");
  }

  void setOnMessageReceived(Function(String) callback) {
    onMessageRecived = callback;
  }

  void setOnContributionRequest(Function(Map<String, dynamic>) callback) {
    onContributionRequest = callback;
  }

  void setOnCoHostJoined(Function(Map<String, dynamic>) callback) {
    onCoHostJoined = callback;
  }

  void setOnCoHostLeft(Function(Map<String, dynamic>) callback) {
    onCoHostLeft = callback;
  }

  void setOnHostTransferred(Function(Map<String, dynamic>) callback) {
    onHostTransferred = callback;
  }

  void setOnBadWordWarning(Function(Map<String, dynamic>) callback) {
    onBadWordWarning = callback;
  }

  void setOnUserBanned(Function(Map<String, dynamic>) callback) {
    onUserBanned = callback;
  }

  void notifyCoHostJoined(String streamId, String coHostId, String coHostName) {
    sendMessage({
      "type": "cohost-joined",
      "streamId": streamId,
      "coHostId": coHostId,
      "coHostName": coHostName,
    });
  }

  void notifyCoHostLeft(String streamId, String coHostId) {
    sendMessage({
      "type": "cohost-left",
      "streamId": streamId,
      "coHostId": coHostId,
    });
  }

  void notifyHostTransferred(String streamId, String oldHostId, String newHostId) {
    sendMessage({
      "type": "host-transferred",
      "streamId": streamId,
      "oldHostId": oldHostId,
      "newHostId": newHostId,
    });
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}