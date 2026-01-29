import 'package:elites_live/features/profile/presentation/widget/my_recorded_live_tab.dart';
import 'package:elites_live/features/profile/presentation/widget/schedule_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/profile_tab_controller.dart';




class ProfileTabsWidget extends StatelessWidget {
  const ProfileTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileTabsController controller = Get.find();


    return Column(
      children: [
        // Tabs
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 12.h),
          child: Obx(
                () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem(
                  controller: controller,
                  index: 0,
                  activeIcon: controller.gridActive,
                  inactiveIcon: controller.gridInactive,
                ),
                _buildTabItem(
                  controller: controller,
                  index: 1,
                  activeIcon: controller.scheduleActive,
                  inactiveIcon: controller.scheduleInactive,
                ),

              ],
            ),
          ),
        ),

        SizedBox(height: 10.h),

        // Tab Content - Use IndexedStack to keep all widgets alive
        Obx(
              () => IndexedStack(
            index: controller.selectedIndex.value,
            sizing: StackFit.loose,
            children: [
              MyRecordedLiveSession(),
              EventScheduleTab(),

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem({
    required ProfileTabsController controller,
    required int index,
    required String activeIcon,
    required String inactiveIcon,
  }) {
    bool isActive = controller.selectedIndex.value == index;

    return GestureDetector(
      onTap: () => controller.selectedIndex.value = index,
      child: Column(
        children: [
          Image.asset(
            isActive ? activeIcon : inactiveIcon,
            height: 26.h,
            width: 26.w,
          ),
          SizedBox(height: 4.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2.h,
            width: 50.w,
            decoration: BoxDecoration(
              gradient: isActive
                  ? AppColors.primaryGradient
                  : const LinearGradient(
                colors: [Colors.transparent, Colors.transparent],
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
        ],
      ),
    );
  }
}





