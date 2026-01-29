

import 'dart:async';

import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../routes/app_routing.dart';

/*class SplashController extends GetxController {
  final SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

  @override
  Future<void> onInit() async {
    super.onInit();

    await preferencesHelper.init();

    final String? token = preferencesHelper.getString("userToken");
    final isOnBoarding = preferencesHelper.getBool("onBoarding") ?? false;
    final isSetup = preferencesHelper.getBool("isSetup") ?? false;

    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 2));

    // Single navigation based on conditions
    if (token != null && token.isNotEmpty) {
      if (isSetup) {
        Get.offAllNamed(AppRoute.mainView);
      } else {
        Get.offAllNamed(AppRoute.setupProfile);
      }
    } else {
      if (isOnBoarding) {
        Get.offAllNamed(AppRoute.signIn);
      } else {
        Get.offAllNamed(AppRoute.slider);
      }
    }
  }
}*/

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/helper/shared_prefarenses_helper.dart';
import '../../../routes/app_routing.dart';

class SplashController extends GetxController {
  final SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

  @override
  Future<void> onInit() async {
    super.onInit();

    try {
      // Initialize SharedPreferences with timeout
      await preferencesHelper.init().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          if (kDebugMode) {
            print("SharedPreferences initialization timeout");
          }
          throw TimeoutException('Failed to initialize SharedPreferences');
        },
      );

      // Wait for splash duration
      await Future.delayed(const Duration(seconds: 2));

      // Navigate based on user state
      _navigateToNextScreen();

    } catch (e) {
      if (kDebugMode) {
        print("Error in splash controller: $e");
      }
      // Fallback navigation in case of error
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppRoute.slider);
    }
  }

  void _navigateToNextScreen() {
    try {
      final String? token = preferencesHelper.getString("userToken");
      final bool isOnBoarding = preferencesHelper.getBool("onBoarding") ?? false;
      final bool isSetup = preferencesHelper.getBool("isSetup") ?? false;

      if (token != null && token.isNotEmpty) {
        if (isSetup) {
          Get.offAllNamed(AppRoute.mainView);
        } else {
          Get.offAllNamed(AppRoute.setupProfile);
        }
      } else {
        if (isOnBoarding) {
          Get.offAllNamed(AppRoute.signIn);
        } else {
          Get.offAllNamed(AppRoute.slider);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Navigation error: $e");
      }
      Get.offAllNamed(AppRoute.slider);
    }
  }
}
