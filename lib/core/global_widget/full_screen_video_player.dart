import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';

import '../utils/constants/app_colors.dart';
import 'custom_loading.dart';
import 'custom_text_view.dart';
class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String title;
  final String description;

  const FullScreenVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.title,
    required this.description,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isInitialized = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });
      _controller.addListener(() {
        if (mounted) {
          setState(() {
            _isPlaying = _controller.value.isPlaying;
          });
        }
      });
      // Auto play
      _controller.play();
    } catch (e) {
      debugPrint('Error initializing video: $e');
      Get.snackbar(
        'Error',
        'Failed to load video',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              color: Colors.black.withValues(alpha: 0.8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextView(
                          text: widget.title,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          maxLines: 1,
                        ),
                        SizedBox(height: 2.h),
                        CustomTextView(
                          text: widget.description,
                          fontSize: 12.sp,
                          color: Colors.grey.shade400,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Video Player
            Expanded(
              child: Center(
                child: _isInitialized
                    ? GestureDetector(
                  onTap: _toggleControls,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),

                      // Play/Pause Overlay
                      if (_showControls)
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            color: Colors.black.withValues(alpha: 0.3),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
                    : Center(
                  child: CustomLoading(color: AppColors.primaryColor),
                ),
              ),
            ),

            // Video Controls
            if (_isInitialized)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: Colors.black.withValues(alpha: 0.8),
                child: Column(
                  children: [
                    // Progress Bar
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: AppColors.primaryColor,
                        bufferedColor: Colors.grey.shade700,
                        backgroundColor: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Time and Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextView(
                          text: _formatDuration(_controller.value.position),
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.replay_10,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final newPosition = _controller.value.position -
                                    const Duration(seconds: 10);
                                _controller.seekTo(newPosition);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.forward_10,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                final newPosition = _controller.value.position +
                                    const Duration(seconds: 10);
                                _controller.seekTo(newPosition);
                              },
                            ),
                          ],
                        ),
                        CustomTextView(
                          text: _formatDuration(_controller.value.duration),
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}