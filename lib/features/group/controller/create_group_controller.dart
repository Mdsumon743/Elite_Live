import 'dart:convert';
import 'dart:developer';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class CreateGroupController extends GetxController {
  final groupNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final NetworkCaller networkCaller = NetworkCaller();
  var isLoading = false.obs;
  final SharedPreferencesHelper helper = SharedPreferencesHelper();

  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isPublic = false.obs;
  final ImagePicker _picker = ImagePicker();


  /// create Group
  ///
  /// need to update is public
  Future<void> createGroup() async {
    if (groupNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter group name',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedImage.value == null) {
      Get.snackbar(
        'Error',
        'Please select a group photo',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );

    String? token = helper.getString("userToken");
    log("token: $token");

    try {
      var request = http.MultipartRequest("POST", Uri.parse(AppUrls.createGroup));
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "$token",
      });

      // Add fields
      request.fields['groupName'] = groupNameController.text.trim();
      request.fields['description'] = descriptionController.text.trim();
      request.fields['isPublic'] = isPublic.value.toString();

      // Add file
      String filePath = selectedImage.value!.path;
      if (!await selectedImage.value!.exists()) {
        throw Exception("File does not exist");
      }

      String ext = filePath.split('.').last.toLowerCase();
      MediaType type = ['jpg', 'jpeg'].contains(ext)
          ? MediaType('image', 'jpeg')
          : (ext == 'png'
          ? MediaType('image', 'png')
          : MediaType('image', 'jpeg'));

      request.files.add(
        await http.MultipartFile.fromPath(
          'groupPhoto',
          filePath,
          contentType: type,
        ),
      );

      // ================================
      //  🚀 LOG FULL REQUEST BODY HERE
      // ================================
      log("======= MULTIPART REQUEST LOG =======");

      log("Headers:");
      request.headers.forEach((key, value) {
        log("  $key: $value");
      });

      log("Fields:");
      request.fields.forEach((key, value) {
        log("  $key: $value");
      });

      log("Files:");
      for (var file in request.files) {
        log("  Field: ${file.field}");
        log("  Filename: ${file.filename}");
        log("  Content-Type: ${file.contentType}");
        log("  File length: ${file.length}");
      }

      log("======= END REQUEST LOG =======");

      // ================================

      log("Sending request...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isDialogOpen ?? false) Get.back();

        log("Group created: $responseData");

        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Group created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        groupNameController.clear();
        descriptionController.clear();
        selectedImage.value = null;
        isPublic.value = false;
      } else {
        if (Get.isDialogOpen ?? false) Get.back();

        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Failed to create group',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");

      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'An error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  










  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
      Get.back(); // Close bottom sheet
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Pick image from gallery
  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedImage.value = File(image.path);
      }
      Get.back(); // Close bottom sheet
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to select image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Remove selected image
  void removeImage() {
    selectedImage.value = null;
  }

  // Show image picker bottom sheet
  void showImagePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              'Upload Photo',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24.h),

            // Camera option
            _buildPickerOption(
              icon: Icons.camera_alt,
              title: 'Camera',
              subtitle: 'Take a photo',
              onTap: pickImageFromCamera,
            ),

            SizedBox(height: 16.h),

            // Gallery option
            _buildPickerOption(
              icon: Icons.photo_library,
              title: 'Gallery',
              subtitle: 'Choose from gallery',
              onTap: pickImageFromGallery,
            ),

            SizedBox(height: 16.h),

            // Cancel button
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }



  @override
  void onClose() {
    groupNameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
