import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class VideoThumbnail extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnail({super.key, required this.videoUrl});

  @override
  State<VideoThumbnail> createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _controller!.initialize();
      await _controller!.seekTo(const Duration(seconds: 1)); // Get frame at 1 second
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Error loading video thumbnail: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null && _controller!.value.isInitialized) {
      return VideoPlayer(_controller!);
    }

    return Container(
      color: Colors.grey.shade800,
      child: Center(
        child: Icon(
          Icons.video_library,
          size: 40.sp,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}