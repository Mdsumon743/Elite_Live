import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/global_widget/custom_loading.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/global_widget/full_screen_video_player.dart';
import '../../../../core/global_widget/video_thumbnail_card.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/my_schedule_event_controller.dart';



class MyRecordedLiveSession extends StatelessWidget {
  const MyRecordedLiveSession({super.key});

  @override
  Widget build(BuildContext context) {
    final MyScheduleEventController controller =
    Get.find<MyScheduleEventController>();
    Future.microtask(()=>controller.getMyRecording());

    return Obx(() {
      // Loading State
      if (controller.isLoading.value) {
        return Center(
          child: CustomLoading(color: AppColors.primaryColor),
        );
      }

      // Empty State
      if (controller.myRecordingList.isEmpty) {
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
        shrinkWrap: true,
        padding: EdgeInsets.all(8.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 0.7,
        ),
        itemCount: controller.myRecordingList.length,
        itemBuilder: (context, index) {
          final recording = controller.myRecordingList[index];

          // Use recordingLink if available, otherwise use default video
          final videoUrl = recording.recordingLink.isNotEmpty
              ? recording.recordingLink
              : 'https://cdn.pixabay.com/video/2016/08/16/4841-180474205_large.mp4';

          return VideoThumbnailCard(
            videoUrl: videoUrl,
            title: 'Recording ${index + 1}',
            duration: 'Views: ${recording.watchCount}',
            onTap: () {
              // Navigate to full screen video player
              Get.to(() => FullScreenVideoPlayer(
                videoUrl: videoUrl,
                title: 'Recording ${index + 1}',
                description: 'Watch Count: ${recording.watchCount}',
              ));
            },
          );
        },
      );
    });
  }
}