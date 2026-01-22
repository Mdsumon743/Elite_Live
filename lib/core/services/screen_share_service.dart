
import 'dart:developer';
import 'package:flutter/services.dart';

class ScreenShareService {
  static const MethodChannel _channel =
  MethodChannel('com.elitelive.morgan/screenshare');

  /// Start screen sharing (iOS only)
  static Future<bool> startScreenShare({
    required String roomID,
    required String streamID,
  }) async {


    try {
      log('🎬 Starting screen share - Room: $roomID, Stream: $streamID');
      final bool result = await _channel.invokeMethod('startScreenShare', {
        'roomID': roomID,
        'streamID': streamID,
      });

      log('✅ Screen share started: $result');
      return result;
    } on PlatformException catch (e) {
      log('❌ Failed to start screen share: ${e.message}');
      return false;
    }
  }

  /// Stop screen sharing
  static Future<bool> stopScreenShare() async {


    try {
      final bool result = await _channel.invokeMethod('stopScreenShare');
      log('🛑 Screen share stopped: $result');
      return result;
    } on PlatformException catch (e) {
      log('❌ Failed to stop screen share: ${e.message}');
      return false;
    }
  }
}