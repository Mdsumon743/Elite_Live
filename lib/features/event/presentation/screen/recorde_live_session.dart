import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/full_screen_video_player.dart';
import '../../../../core/global_widget/video_thumbnail_card.dart';
import '../../controller/schedule_controller.dart';

class RecordedLiveSession extends StatelessWidget {
  RecordedLiveSession({super.key, required this.userId});

  final String userId;
  final ScheduleController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // ✅ Call API only once when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.otherUserRecordingList.isEmpty && !controller.isLoading.value) {
        controller.getOthersRecording(userId);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        // Loading State
        if (controller.isLoading.value) {
          return Center(
            child: CustomLoading(color: AppColors.primaryColor),
          );
        }

        // Empty State
        if (controller.otherUserRecordingList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_library_outlined,
                  size: 80.sp,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 16.h),
                CustomTextView(
                  text: "No Recorded Sessions Found",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          );
        }

        // Grid View with Videos
        return GridView.builder(
          padding: EdgeInsets.all(8.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.otherUserRecordingList.length,
          itemBuilder: (context, index) {
            final event = controller.otherUserRecordingList[index];
            final videoUrl = (event.recordingLink.isEmpty)
                ? 'https://cdn.pixabay.com/video/2016/08/16/4841-180474205_large.mp4'
                : event.recordingLink;

            return VideoThumbnailCard(
              videoUrl: videoUrl,
              title: event.id,
              duration: event.watchCount.toString(),
              onTap: () {
                Get.to(() => FullScreenVideoPlayer(
                  videoUrl: videoUrl,
                  title: event.id,
                  description: event.id,
                ));
              },
            );
          },
        );
      }),
    );
  }
}





