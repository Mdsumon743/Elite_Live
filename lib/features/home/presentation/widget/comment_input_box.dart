
import 'package:elites_live/core/utils/constants/app_colors.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/home_controller.dart';


class CommentInputBox extends StatelessWidget {
  final HomeController controller = Get.find();

  final RxString replyingToId = ''.obs;
  final RxString replyingToName = ''.obs;

  final VoidCallback? onTap; // <-- FIXED: now passed through constructor

  CommentInputBox({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// ----------------------------------------------------------
        /// DISPLAY SELECTED IMAGE
        /// ----------------------------------------------------------
        Obx(() {
          final image = controller.commentImage.value;
          return image != null
              ? Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(image, height: 120),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => controller.commentImage.value = null,
                    child: const CircleAvatar(
                      backgroundColor: Colors.black54,
                      radius: 12,
                      child: Icon(Icons.close,
                          size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink();
        }),

        /// ----------------------------------------------------------
        /// INPUT BAR
        /// ----------------------------------------------------------
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              /// COMMENT TEXT FIELD
              Expanded(
                child: TextField(
                  controller: controller.commentController,
                  decoration: InputDecoration(
                    hintText: 'Type a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),

              /// EMOJI BUTTON
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: () => controller.toggleEmojiKeyboard(),
              ),

              /// IMAGE PICKER BUTTON
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  Get.bottomSheet(
                    Container(
                      padding: const EdgeInsets.all(16),
                      height: 150,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              controller.pickImage(ImageSource.camera);
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Camera"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              controller.pickImage(ImageSource.gallery);
                            },
                            icon: const Icon(Icons.photo_library),
                            label: const Text("Gallery"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              /// SEND BUTTON
              IconButton(
                icon: Icon(Icons.send, color: AppColors.primaryColor),
                onPressed: () {
                  if (onTap != null) {
                    onTap!(); // <-- FIXED: properly calls parent callback
                  }
                },
              ),
            ],
          ),
        ),

        /// ----------------------------------------------------------
        /// EMOJI PICKER
        /// ----------------------------------------------------------
        Obx(() {
          if (!controller.isEmojiVisible.value) return const SizedBox.shrink();
          return SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: (category, emoji) {
                controller.commentController.text += emoji.emoji;
              },
            ),
          );
        }),
      ],
    );
  }
}
