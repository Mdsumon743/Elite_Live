import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:elites_live/core/services/duration_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';


import '../../controller/video_player_controller.dart';



class VideoPlayerSection extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerSection({super.key, required this.videoUrl});

  @override
  State<VideoPlayerSection> createState() => _VideoPlayerSectionState();
}

class _VideoPlayerSectionState extends State<VideoPlayerSection> {
  late VideoController videoController;

  @override
  void initState() {
    super.initState();

    final validUrl = widget.videoUrl.isEmpty
        ? 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
        : widget.videoUrl;

    // ✅ Create unique instance for each video
    videoController = VideoController(validUrl);
    videoController.onInit();
  }

  @override
  void dispose() {
    videoController.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF000000).withValues(alpha: 0.1),
            const Color(0xFF000000),
          ],
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final isInitialized =
            videoController.videoPlayerController.value.isInitialized;
        final isPlaying = videoController.isPlaying.value;
        final isMuted = videoController.isMuted.value;
        final pos = videoController.position.value;
        final dur = videoController.duration.value;
        final hasError = videoController.hasError.value;
        final progress =
        dur.inMilliseconds > 0 ? pos.inMilliseconds / dur.inMilliseconds : 0.0;

        return Stack(
          alignment: Alignment.center,
          children: [
            // VIDEO PLAYER OR ERROR
            if (hasError)
              Container(
                height: 200.h,
                color: Colors.black87,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 48.sp),
                      SizedBox(height: 8.h),
                      CustomTextView(
                        text: "Video unavailable",
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ],
                  ),
                ),
              )
            else if (isInitialized)
              AspectRatio(
                aspectRatio:
                videoController.videoPlayerController.value.aspectRatio,
                child: VideoPlayer(videoController.videoPlayerController),
              )
            else
              Container(
                height: 200.h,
                color: Colors.black87,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),

            // PLAY / PAUSE BUTTON
            if (!hasError)
              IconButton(
                iconSize: 60.sp,
                onPressed: videoController.togglePlayPause,
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),

            // CONTROLS
            if (!hasError && isInitialized)
              Positioned(
                bottom: 2.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  children: [
                    Slider(
                      value: progress.clamp(0.0, 1.0),
                      activeColor: Colors.blueAccent,
                      inactiveColor: Colors.white30,
                      onChanged: (value) {
                        final newPosition = dur * value;
                        videoController.videoPlayerController.seekTo(newPosition);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(text: Format.formatDuration(pos)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: videoController.toggleMute,
                              child: Icon(
                                isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 10.w),
                            CustomTextView(text: Format.formatDuration(dur)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
          ],
        );
      }),
    );
  }
}


