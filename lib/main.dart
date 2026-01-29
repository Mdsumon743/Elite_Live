import 'package:elites_live/core/services/push_notification_service.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:elites_live/core/services/auth_service.dart';
import 'package:elites_live/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'core/binding/app_binding.dart';

import 'core/services/socket_service.dart';
import 'features/live/controller/GlobalWebSocketHandler.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AuthService().init();
  await PushNotificationService().initialize();
  AppBinding().dependencies();
  Get.put(GlobalWebSocketHandler());
  Get.put(WebSocketClientService(), permanent: true);

  // Initialize Zego


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}


