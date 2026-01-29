import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:elites_live/routes/app_routing.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This MUST be a top-level function (outside any class)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp();

  developer.log("🔔 Background message received!");
  developer.log("Title: ${message.notification?.title}");
  developer.log("Body: ${message.notification?.body}");
  developer.log("Data: ${message.data}");

  // Show notification on Android even in background
  if (Platform.isAndroid) {
    // Create a new instance for background handling
    final service = PushNotificationService();
    await service.initializeLocalNotificationsOnly();
    await service.showNotificationPublic(message);
  }
}

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Singleton pattern
  static final PushNotificationService _instance =
  PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  /// Initialize Push Notification Service
  Future<void> initialize() async {
    try {
      /// 🔹 STEP 1: Register background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      /// 🔹 STEP 2: Request notification permission
      NotificationSettings settings =
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: false,
      );

      developer.log(
          "📋 Notification Permission Status: ${settings.authorizationStatus}");

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        developer.log("❌ User denied notification permissions");
        return;
      }

      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        developer.log("⚠️ Notification permissions not determined");
        return;
      }

      developer.log("✅ User granted notification permissions");

      /// 🔹 STEP 3: Set iOS foreground presentation behavior
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      /// 🔹 STEP 4: Initialize local notifications BEFORE getting tokens
      await initializeLocalNotificationsOnly();

      /// 🔹 STEP 5: iOS - get APNs token
      if (Platform.isIOS) {
        String? apnsToken;
        int attempts = 0;
        const int maxAttempts = 20;

        do {
          apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken == null) {
            developer.log("⏳ Waiting for APNs token... Attempt ${attempts + 1}");
            await Future.delayed(const Duration(seconds: 1));
          }
          attempts++;
        } while (apnsToken == null && attempts < maxAttempts);

        if (apnsToken == null) {
          developer.log("⚠️ Failed to get APNs token after $maxAttempts attempts.");
          developer.log("⚠️ Troubleshooting:");
          developer.log("   1. Check APNs certificate in Firebase Console");
          developer.log("   2. Enable Push Notifications in Xcode capabilities");
          developer.log("   3. Test on real device (not simulator)");
        } else {
          developer.log("📱 APNs Token: $apnsToken");
        }
      }

      /// 🔹 STEP 6: Get FCM token with retry logic
      String? token = await _getFCMTokenWithRetry();

      if (token != null) {
        // ✅ Save FCM token to SharedPreferences
        await _saveFCMToken(token);
        developer.log("✅ FCM Token saved to SharedPreferences");
      } else {
        developer.log("❌ Failed to get FCM token");
      }

      /// 🔹 STEP 7: Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        developer.log("🔄 FCM Token refreshed: $newToken");
        developer.log("📤 Update this token on your backend!");

        // Save new token
        await _saveFCMToken(newToken);
      });

      /// 🔹 STEP 8: Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        developer.log("📥 Foreground message received!");
        developer.log("Title: ${message.notification?.title ?? 'No title'}");
        developer.log("Body: ${message.notification?.body ?? 'No body'}");
        developer.log("Data: ${message.data}");

        // Show notification for both platforms
        if (message.notification != null) {
          showNotificationPublic(message);
        } else if (message.data.isNotEmpty) {
          _handleDataOnlyMessage(message);
        }
      });

      /// 🔹 STEP 9: When app is opened from background notification
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        developer.log("🔁 App opened from background notification");
        developer.log("Notification data: ${message.data}");
        _navigateToScreen(message);
      });

      /// 🔹 STEP 10: When app is opened from terminated state
      RemoteMessage? initialMessage =
      await _firebaseMessaging.getInitialMessage();

      if (initialMessage != null) {
        developer.log("🚀 App opened from terminated notification");
        developer.log("Notification data: ${initialMessage.data}");

        Future.delayed(const Duration(milliseconds: 800), () {
          _navigateToScreen(initialMessage);
        });
      }

      developer.log("✅ Push notification service initialized successfully");
    } catch (e, stackTrace) {
      developer.log("❌ Error initializing push notifications: $e");
      developer.log("Stack trace: $stackTrace");
    }
  }

  /// Get FCM token with retry logic
  Future<String?> _getFCMTokenWithRetry() async {
    String? token;
    int attempts = 0;
    const int maxAttempts = 10;

    do {
      try {
        token = await _firebaseMessaging.getToken();
        if (token != null) {
          developer.log("🔥 FCM Token: $token");
        } else {
          developer.log("⏳ Waiting for FCM token... Attempt ${attempts + 1}");
          await Future.delayed(const Duration(seconds: 1));
        }
      } catch (e) {
        developer.log("❌ Error getting token: $e");
        await Future.delayed(const Duration(seconds: 1));
      }
      attempts++;
    } while (token == null && attempts < maxAttempts);

    if (token == null) {
      developer.log("❌ Failed to get FCM token after $maxAttempts attempts");
    }

    return token;
  }

  /// Save FCM token to SharedPreferences
  Future<void> _saveFCMToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', token);
      developer.log("💾 FCM Token saved: ${token.substring(0, 20)}...");
    } catch (e) {
      developer.log("❌ Error saving FCM token: $e");
    }
  }

  /// Get saved FCM token from SharedPreferences
  static Future<String?> getSavedFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('fcm_token');
      if (token != null) {
        developer.log("📱 Retrieved FCM Token: ${token.substring(0, 20)}...");
      } else {
        developer.log("⚠️ No FCM token found in SharedPreferences");
      }
      return token;
    } catch (e) {
      developer.log("❌ Error getting FCM token: $e");
      return null;
    }
  }

  /// PUBLIC: Initialize local notifications (can be called from background handler)
  Future<void> initializeLocalNotificationsOnly() async {
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'Used for important notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          developer.log("📲 Local notification clicked");
          developer.log("Payload: ${response.payload}");

          if (response.payload != null) {
            _handleNotificationTap(response.payload!);
          }
        },
      );

      developer.log("✅ Local notifications initialized");
    } catch (e) {
      developer.log("❌ Error initializing local notifications: $e");
    }
  }

  /// PUBLIC: Show notification (can be called from background handler)
  Future<void> showNotificationPublic(RemoteMessage message) async {
    try {
      if (message.notification == null) {
        developer.log("⚠️ No notification payload");
        return;
      }

      final payload = jsonEncode({
        'title': message.notification?.title ?? '',
        'body': message.notification?.body ?? '',
        'time': message.sentTime?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'data': message.data,
      });

      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        message.messageId.hashCode,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? 'You have a new message',
        notificationDetails,
        payload: payload,
      );

      developer.log("✅ Notification shown");
    } catch (e) {
      developer.log("❌ Error showing notification: $e");
    }
  }

  /// Handle data-only messages
  void _handleDataOnlyMessage(RemoteMessage message) {
    developer.log("🧾 Processing data-only message: ${message.data}");

    if (message.data.isNotEmpty) {
      final title = message.data['title'] ??
          message.data['senderName'] ??
          'New Notification';
      final body = message.data['body'] ??
          message.data['message'] ??
          'You have a new message';

      _showCustomNotification(
        title: title,
        body: body,
        data: message.data,
      );
    }
  }

  /// Show custom notification for data-only messages
  Future<void> _showCustomNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = jsonEncode({
        'title': title,
        'body': body,
        'time': DateTime.now().toIso8601String(),
        'data': data ?? {},
      });

      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Used for important notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      developer.log("✅ Custom notification shown");
    } catch (e) {
      developer.log("❌ Error showing custom notification: $e");
    }
  }

  /// Handle notification tap
  void _handleNotificationTap(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      developer.log("🔍 Notification tapped with data: $data");

      final notificationData = data['data'] as Map<String, dynamic>?;

      if (notificationData != null && notificationData.isNotEmpty) {
        _navigateBasedOnData(notificationData);
      } else {
        Get.toNamed(AppRoute.notification);
      }
    } catch (e) {
      developer.log("❌ Error parsing notification payload: $e");
    }
  }

  /// Navigate when user taps notification
  void _navigateToScreen(RemoteMessage message) {
    final data = message.data;
    developer.log("🔍 Navigate to screen with data: $data");

    if (data.isNotEmpty) {
      _navigateBasedOnData(data);
    } else {
      Get.toNamed(AppRoute.notification);
    }
  }

  /// Central navigation logic
  void _navigateBasedOnData(Map<String, dynamic> data) {
    developer.log("🧭 Navigating based on data: $data");

    final type = data['type'] as String?;
    final typeId = data['typeId'] as String?;
    final senderId = data['senderId'] as String?;

    if (type == null) {
      developer.log("⚠️ No type found, going to notification screen");
      Get.toNamed(AppRoute.notification);
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      switch (type.toLowerCase()) {
        case 'feedback':
          developer.log('📋 Navigating to: Feedback Details');
          if (typeId != null) {
            // Get.toNamed(AppRoute.feedbackDetails, arguments: typeId);
          }
          break;

        case 'message':
          developer.log('💬 Navigating to: Chat Screen');
          if (senderId != null) {
            // Get.toNamed(AppRoute.createChat, arguments: senderId);
          }
          break;

        case 'order':
          developer.log('🛒 Navigating to: Services Tab');
          break;

        case 'session':
          developer.log('📅 Navigating to: Sessions Tab');
          break;

        default:
          developer.log('⚠️ Unknown type: $type');
          Get.toNamed(AppRoute.notification);
      }
    });
  }

  /// Get current FCM token
  Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        developer.log("📱 Current FCM Token: ${token.substring(0, 20)}...");
      }
      return token;
    } catch (e) {
      developer.log("❌ Error getting FCM token: $e");
      return null;
    }
  }

  /// Delete FCM token (for logout)
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();

      // Remove from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fcm_token');

      developer.log("🗑️ FCM token deleted");
    } catch (e) {
      developer.log("❌ Error deleting FCM token: $e");
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      developer.log("✅ Subscribed to topic: $topic");
    } catch (e) {
      developer.log("❌ Error subscribing to topic: $e");
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      developer.log("✅ Unsubscribed from topic: $topic");
    } catch (e) {
      developer.log("❌ Error unsubscribing from topic: $e");
    }
  }
}