
import 'package:elites_live/features/event/controller/event_controller.dart';
import 'package:elites_live/features/event/controller/schedule_controller.dart';
import 'package:elites_live/features/group/controller/group_controller.dart';
import 'package:elites_live/features/group/controller/group_post_controller.dart';
import 'package:elites_live/features/group/controller/invite_group_controller.dart';
import 'package:elites_live/features/group/controller/my_group_controller.dart';
import 'package:elites_live/features/home/controller/home_controller.dart';
import 'package:elites_live/features/home/controller/live_controller.dart';
import 'package:elites_live/features/home/controller/video_player_controller.dart';
import 'package:elites_live/features/live/controller/live_screen_controller.dart';
import 'package:elites_live/features/profile/controller/earning_overview_controller.dart';
import 'package:elites_live/features/profile/controller/edit_profile_controller.dart';
import 'package:elites_live/features/profile/controller/following_follwer_controller.dart';
import 'package:elites_live/features/profile/controller/my_crowd_funding_controller.dart';
import 'package:elites_live/features/profile/controller/my_schedule_event_controller.dart';
import 'package:elites_live/features/profile/controller/profile_controller.dart';
import 'package:elites_live/features/profile/controller/profile_tab_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/authentication/forgot_pass/controller/create_new_pass_controller.dart';
import '../../features/authentication/forgot_pass/controller/forgot_otp_controller.dart';
import '../../features/authentication/forgot_pass/controller/forgot_pass_controller.dart';

import '../../features/authentication/set_up_profile/controller/set_up_profile_controller.dart';
import '../../features/authentication/sign_in/controller/sign_in_controller.dart';
import '../../features/authentication/sign_up/controller/sign_up_controller.dart';
import '../../features/authentication/sign_up/controller/sign_up_otp_controller.dart';
import '../../features/live/controller/GlobalWebSocketHandler.dart';
import '../../features/main_view/controller/main_view_controller.dart';
import '../../features/on_boarding/controller/slider_controller.dart';

import '../../features/splash/controller/splash_controller.dart';
import '../global_widget/controller/custom_date_time_dialogue.dart';
import '../services/socket_service.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    // Get.lazyPut(() => SearchScreenController(), fenix: true);
    Get.lazyPut(() => SliderController(), fenix: true);
    Get.lazyPut(() => SignInController(), fenix: true);
    Get.lazyPut(() => SignUpController(), fenix: true);
    Get.lazyPut(() => SignUpOtpController(), fenix: true);
    Get.lazyPut(() => ForgotPassController(), fenix: true);
    Get.lazyPut(() => ForgotOtpController(), fenix: true);
    Get.lazyPut(() => CreateNewPassController(), fenix: true);
    Get.lazyPut(() => SetUpProfileController(), fenix: true);
    Get.lazyPut(() => CustomDateTimeController(), fenix: true);
    Get.lazyPut(() => MainViewController(), fenix: true);
    Get.lazyPut(()=>HomeController(), fenix: true);
    ////Get.lazyPut(()=>VideoController(), fenix: true);
    Get.lazyPut(()=>LiveController(), fenix: true);
    Get.lazyPut(()=>GroupController(), fenix: true);
    Get.lazyPut(()=>EventController(), fenix: true);
    Get.lazyPut(()=>ProfileController(), fenix: true);
    Get.lazyPut(()=>EditProfileController(), fenix: true);
    Get.lazyPut(()=>ProfileTabsController(), fenix: true);
    Get.lazyPut(()=>ScheduleController(), fenix: true);
    Get.lazyPut(()=>EventController(), fenix: true);
    Get.lazyPut(()=>MyGroupController(), fenix: true);
    Get.lazyPut(()=>GroupPostController(), fenix: true);
    Get.lazyPut(()=>InviteGroupController(), fenix: true);
    Get.lazyPut(()=>MyScheduleEventController(), fenix: true);
    Get.lazyPut(()=>MyCrowdFundController(), fenix: true);
    Get.lazyPut(()=>FollowingFollwerController(), fenix: true);
    Get.lazyPut(()=>EarningsController(), fenix: true);
    Get.lazyPut(()=>LiveScreenController(), fenix: true);
    Get.lazyPut(()=>SearchController(), fenix: true);
    Get.put(WebSocketClientService(), permanent: true);
    Get.put(GlobalWebSocketHandler(), permanent: true);

  }
}