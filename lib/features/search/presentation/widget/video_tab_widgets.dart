import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controller/search_controller.dart';


import 'package:video_player/video_player.dart';






class VideoTabWidget extends StatelessWidget {
  const VideoTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchScreenController controller = Get.find<SearchScreenController>();

    return Obx(() {
      final videos = controller.allRecordingList;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'Video',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),

          ListView.builder(
            itemCount: videos.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final item = videos[index];
              return VideoCard(
                videoUrl: item.recordingLink,
                name: item.user.firstName,
                username: item.user.lastName,
                views: item.watchCount.toString(),
                recordingId: item.id,
              );
            },
          ),
        ],
      );
    });
  }
}

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String username;
  final String views;
  final String recordingId;

  const VideoCard({
    super.key,
    required this.videoUrl,
    required this.name,
    required this.username,
    required this.views,
    required this.recordingId,
  });

  @override
  State<VideoCard> createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _hasError = false;
  String _duration = "0:00";

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );

      await _videoController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _duration = _formatDuration(_videoController!.value.duration);
        });
      }

      _videoController!.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _videoController!.value.isPlaying;
          });
        }
      });
    } catch (e) {
      log('Error initializing video: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '$minutes:${twoDigits(seconds)}';
  }

  void _togglePlayPause() {
    if (_videoController == null || !_isInitialized) return;

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
    } else {
      _videoController!.play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _togglePlayPause,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    height: 60.h,
                    width: 60.w,
                    color: Colors.black,
                    child: _hasError
                        ? Icon(Icons.error_outline,
                        color: Colors.white, size: 24.sp)
                        : _isInitialized
                        ? AspectRatio(
                      aspectRatio:
                      _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                        : Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                    ),
                  ),
                ),

                if (_isInitialized && !_hasError)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28.sp,
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          /// ---- MAIN CONTENT + RIGHT SIDE VIEW COUNT ----
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT TEXT SECTION
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF191919),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        widget.username,
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF636F85),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14.sp, color: Colors.grey.shade500),
                          SizedBox(width: 4.w),
                          Text(
                            _duration,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// ---- RIGHT SIDE VIEW COUNT ----
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_red_eye,
                        size: 16.sp, color: Colors.grey.shade600),
                    SizedBox(height: 4.h),
                    Text(
                      widget.views,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

