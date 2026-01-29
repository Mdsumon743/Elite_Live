import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoController extends GetxController {
  late VideoPlayerController videoPlayerController;

  final String videoUrl;

  var isPlaying = false.obs;
  var isMuted = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  var hasError = false.obs;

  VideoController(this.videoUrl);

  @override
  void onInit() {
    super.onInit();

    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
    )..initialize().then((_) {
      duration.value = videoPlayerController.value.duration;
      hasError.value = false;
      update();
      // videoPlayerController.play(); // ✅ Remove auto-play for better control
    }).catchError((error) {
      print('Video load error: $error');
      hasError.value = true;
      update();
    });

    videoPlayerController.addListener(() {
      position.value = videoPlayerController.value.position;
      duration.value = videoPlayerController.value.duration;
      isPlaying.value = videoPlayerController.value.isPlaying;

      if (videoPlayerController.value.hasError) {
        hasError.value = true;
      }
    });
  }

  void togglePlayPause() {
    if (isPlaying.value) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    videoPlayerController.setVolume(isMuted.value ? 0 : 1);
  }

  @override
  void onClose() {
    videoPlayerController.dispose();
    super.onClose();
  }
}

