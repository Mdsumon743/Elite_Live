import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/notification_controller.dart';
import '../widget/notification_item.dart';



class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          // Gradient Header
          Container(
            height: 190.h,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Notification",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Notification List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CustomLoading(color: AppColors.primaryColor),
                );
              }

              if (controller.notificationList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      CustomTextView(
                        text: 'No notifications yet',
                        fontSize: 16.sp,
                      ),
                    ],
                  ),
                );
              }

              final grouped = controller.groupedNotifications;

              // Build a single scrollable list with headers and items
              final children = <Widget>[];
              grouped.forEach((header, items) {
                children.add(
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                    child: CustomTextView(
                      text: header,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeader,
                    ),
                  ),
                );

                for (var i = 0; i < items.length; i++) {
                  children.add(NotificationItem(notification: items[i], controller: controller));
                  if (i != items.length - 1) {
                    children.add(Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[200],
                      indent: 80.w,
                    ));
                  }
                }

                // spacing between groups
                children.add(SizedBox(height: 12.h));
              });

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.r),
                    topRight: Radius.circular(50.r),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: children,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

