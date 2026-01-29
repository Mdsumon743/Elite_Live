
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../routes/app_routing.dart';

class GoogleSignInHelper {
  static final GoogleSignInHelper instance = GoogleSignInHelper._internal();
  SharedPreferencesHelper preferencesHelper = SharedPreferencesHelper();

  GoogleSignInHelper._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxBool isLoading = false.obs;

  /*Future<User?> signInWithGoogle() async {
    debugPrint("🔄 Initiating Google sign-in process...======>>>>>>>>");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        debugPrint(
          "✅ Google sign-in successful: ${user.displayName}, ${user.email}",
        );
        var userInfo = {
          'email': user.email ?? '',
          'firstName': user.displayName ?? '',
          'photoUrl': user.photoURL ?? '',
        };

        final response = await NetworkCaller().postRequest(AppUrls.googleAuth, body: userInfo);
        if (response.isSuccess) {
          
        } else {
          debugPrint("❌ Backend Google auth failed.");
        }
      }

      return user;
    } catch (e) {
      debugPrint("❌ Error during Google sign-in: $e");
      return null;
    }
  }*/

  Future<Map<String, dynamic>?> signInWithGoogle() async {
    debugPrint("🔄 Initiating Google sign-in process...======>>>>>>>>");
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;

      if (user != null) {
        isLoading.value = true;
        debugPrint(
          "✅ Google sign-in successful: ${user.displayName}, ${user.email}",
        );
        var userInfo = {
          'email': user.email ?? '',
          'firstName': user.displayName ?? '',
          'lastName' : user.displayName ?? '',
          'fcmToken': "e57w54w4e4w4ewerr",
        };

        final response = await NetworkCaller().postRequest(
          AppUrls.googleAuth,
          body: userInfo,
        );
        if (response.isSuccess) {
          preferencesHelper.setString(
            "userToken",
            response.responseData['accessToken'],
          );
          debugPrint(
            "the api response is =======>>>>>> ${response.responseData}",
          );
          Get.offAllNamed(AppRoute.setupProfile, arguments: {});
          final isSetup = response.responseData['isSetup'];
          if (isSetup) {
            preferencesHelper.setBool("isSetup", isSetup);
            CustomSnackBar.success(title: "Success", message: "User logged in successfully");


            Get.offAllNamed(AppRoute.mainView);
          } else {
            debugPrint("❌ Backend Google auth failed.");
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Error during Google sign-in: $e");
    }finally {
      isLoading.value = false;
    }
    return null;
  }
}
