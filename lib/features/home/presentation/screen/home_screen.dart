import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/home_controller.dart';
import '../widget/home_tab_bar.dart';
import '../widget/top_header.dart';
import 'all_live_screen.dart';
import 'following_screen.dart' hide AllLiveScreen;
import 'live_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //* Top header
            Stack(
              children: [
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                Column(
                  children: [
                    TopHeader(),
                    HomeTabBar(),
                    Container(
                      margin: EdgeInsets.only(top: 25.h),
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      height: 560.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                          child: Obx(() {
                            if (controller.selectedTab.value == 0) {
                              return AllLiveScreen();
                            } else if (controller.selectedTab.value == 1) {
                              return FollowingScreen();
                            } else if (controller.selectedTab.value == 2) {
                              // Navigate to full screen instead of embedding
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Get.to(() => const LiveScreen());
                                controller.selectedTab.value = 0; // Reset tab
                              });
                              return const SizedBox.shrink();
                            } else {
                              return SizedBox(height: 600.h);
                            }
                          })
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}