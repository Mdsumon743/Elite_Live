import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_snackbar.dart';
import 'package:elites_live/core/helper/shared_prefarenses_helper.dart';
import 'package:elites_live/core/services/network_caller/repository/network_caller.dart';
import 'package:elites_live/core/utils/constants/app_colors.dart';
import 'package:elites_live/core/utils/constants/app_urls.dart';
import 'package:elites_live/features/group/controller/my_group_controller.dart';
import 'package:elites_live/features/group/data/post_info_data_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart'as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../data/group_info_data_model.dart';
import 'package:http_parser/http_parser.dart';

class GroupPostController extends GetxController {
  var isLoading = false.obs;
  final NetworkCaller networkCaller = NetworkCaller();
  final SharedPreferencesHelper helper = SharedPreferencesHelper();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController commentController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxBool isPublic = false.obs;
  final ImagePicker _picker = ImagePicker();

  Rx<GroupInfoResult?> groupInfo = Rx<GroupInfoResult?>(null);
  Rx<PostInfoResult?> postInfo = Rx<PostInfoResult?>(null);
  final MyGroupController controller = Get.find();

  /// Get group information
  Future<void> getGroupInfo(String groupId) async {
    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during fetch group info: $token");

    try {
      var response = await networkCaller.getRequest(
        AppUrls.groupInfo(groupId),
        token: token,
      );

      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");

      if (response.isSuccess && response.responseData != null) {
        log("Raw API response: ${response.responseData}");

        Map<String, dynamic> jsonData;

        if (response.responseData is String) {
          jsonData = json.decode(response.responseData);
        } else if (response.responseData is Map<String, dynamic>) {
          jsonData = response.responseData;
        } else {
          throw Exception(
            "Unexpected response type: ${response.responseData.runtimeType}",
          );
        }

        log("Parsed JSON data keys: ${jsonData.keys.toList()}");

        final groupResult = GroupInfoResult.fromJson(jsonData);
        groupInfo.value = groupResult;

        log("SUCCESS! Group parsed: ${groupResult.groupName}");
        log("Total posts: ${groupResult.groupPost.length}");

        if (groupResult.groupPost.isNotEmpty) {
          log("First post by: ${groupResult.groupPost[0].user.firstName}");
        }
      } else {
        log("API call failed or returned null data");
        groupInfo.value = null;
      }
    } catch (e, stackTrace) {
      log("Exception: ${e.toString()}");
      log("Stack trace: $stackTrace");
      groupInfo.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// leave group
   Future<void> leaveGroup(String groupId) async{
    isLoading.value = true;
    Get.dialog(CustomLoading(color: AppColors.primaryColor,), barrierDismissible: false);
    String?token = helper.getString("userToken");
    log("the token during leave group$token");
    try{
      
      var response = await networkCaller.deleteRequest(AppUrls.leaveGroup(groupId), token);
      if(response.isSuccess){
        log("the api response is ${response.responseData}");
        await controller.joinedGroup();
        Get.back();
      }
      
    }
    catch(e){
      log("the exception is ${e.toString()}");
    }
    finally{
      isLoading.value = false;
    }
   }

   /// update Group
  /// Update Group - Add this improved version to GroupPostController
  Future<void> updateGroup(String groupId) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );
    String? token = helper.getString("userToken");
    log("token during update group: $token");

    try {
      var request = http.MultipartRequest(
        "PATCH",
        Uri.parse(AppUrls.updateGroup(groupId)),
      );

      request.headers.addAll({'Authorization': token ?? ''});
      request.fields['groupName'] = groupNameController.text.trim();
      request.fields['description'] = descriptionController.text.trim();
      request.fields['isPublic'] = isPublic.value.toString();

      // Add file only if a new image is selected
      if (selectedImage.value != null) {
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
      }

      // Log request details
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

      log("Sending request...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (Get.isDialogOpen ?? false) Get.back();

        log("Group updated: $responseData");
        CustomSnackBar.success(title: "Success", message: " responseData['message'] ?? 'Group updated successfully',");



        // Clear controllers
        groupNameController.clear();
        descriptionController.clear();
        selectedImage.value = null;
        isPublic.value = false;

        // Close the bottom sheet
        if (Get.isBottomSheetOpen ?? false) Get.back();

        // Refresh the joined groups list
        await controller.joinedGroup();
      } else {
        if (Get.isDialogOpen ?? false) Get.back();

        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Failed to update group',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Exception during update group: ${e.toString()}");

      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'An error occurred while updating the group',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// delete Group
  /// Delete Group - Replace the existing method in GroupPostController
  Future<void> deleteGroup(String groupId) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );
    String? token = helper.getString("userToken");
    log("token during delete group: $token");

    try {
      var response = await networkCaller.deleteRequest(
        AppUrls.deleteGroup(groupId),
        token,
      );

      if (Get.isDialogOpen ?? false) Get.back();

      if (response.isSuccess) {
        log("Delete response: ${response.responseData}");



        // Refresh the joined groups list
        await controller.joinedGroup();
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete group',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      log("Exception during delete group: ${e.toString()}");

      if (Get.isDialogOpen ?? false) Get.back();



    } finally {
      isLoading.value = false;
    }
  }

  /// create group post

  Future<void> createGroupPost(String groupId) async {
    isLoading.value = true;
    Get.dialog(
      CustomLoading(color: AppColors.primaryColor),
      barrierDismissible: false,
    );
    String? token = helper.getString("userToken");
    log("token during create group post: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.createGroupPost(groupId),
        body: {
          "content": contentController.text.trim(),
        },
        token: token,
      );


      if (Get.isDialogOpen ?? false) Get.back();

      if (response.isSuccess) {
        log("API response: ${response.responseData}");
        CustomSnackBar.success(title: "Success", message: "Group post created successfully");




        contentController.clear();


        await getGroupInfo(groupId);


        Get.back();
      } else {
        // Show error message
        CustomSnackBar.error(title: "Error", message: "An error occurred while creating the post");

      }
    } catch (e) {
      log("Exception during create group post: ${e.toString()}");

      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) Get.back();

      // Show error message
      CustomSnackBar.error(title: "Error", message: "An error occurred while creating the post");

    } finally {
      isLoading.value = false;
    }
  }

  /// delete group post
  Future<void> deleteGroupPost(String postId,) async {
    isLoading.value = true;

    String? token = helper.getString("userToken");
    log("Token during delete group post: $token");
    log("Delete post: $postId");

    try {
      var response = await networkCaller.deleteRequest(
        AppUrls.deleteGroupPost(postId),
        token,
      );

      // Close loading dialog
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.isSuccess) {
        log("Delete post success: ${response.responseData}");

        // Show success message
        CustomSnackBar.success(title: "Success", message: "Post deleted successfully");


        // Refresh group info to update the post list
        ///await getGroupInfo(groupId);
      } else {
        // Show error message
        CustomSnackBar.error(title: "Error", message: "An error occurred while deleting the post");
      }
    } catch (e) {
      log("Exception during delete group post: ${e.toString()}");

      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) Get.back();

      // Show error message
      CustomSnackBar.error(title: "Error", message: "An error occurred while deleting the post");

    } finally {
      isLoading.value = false;
    }
  }
  /// delete group post
  Future<void> createPostComment(String postId) async {
    if (commentController.text.trim().isEmpty) {

      return;
    }

    isLoading.value = true;
    String? token = helper.getString("userToken");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.createPostComment(postId),
        body: {"comment": commentController.text.trim()},
        token: token,
      );

      if (response.isSuccess) {


        // Clear comment field
        commentController.clear();

        // Refresh post information to show new comment
        await getPostInformation(postId);
      }
    } catch (e) {
      log("Error creating comment: ${e.toString()}");

    } finally {
      isLoading.value = false;
    }
  }


   /// create Like Unlike
   Future<void> likePost(String postId) async{
    isLoading.value = true;
    String?token = helper.getString("userToken");
    log("the token during like post is $token");
    try{
      var response = await networkCaller.postRequest(AppUrls.likePost(postId), body: {}, token: token);
      if(response.isSuccess){
        log("the api response is ${response.responseData}");

        Get.back();
        await getPostInformation(postId);
      }
      
    }
    catch(e){
      log("the error is ${e.toString()}");
      if (Get.isDialogOpen ?? false) Get.back();

      // Show error message
      CustomSnackBar.error(title: "Error", message: "An error occurred while creating the post");
    }
    
    finally{
      isLoading.value = false;
    }
   }

   /// get post information
  Future<void> getPostInformation(String postId)async{
    isLoading.value = true;
    String?token = helper.getString("userToken");
    log("the token during like post is $token");

    try{
      var response = await networkCaller.getRequest(AppUrls.getPostInfo(postId), token: token);
      log("Response isSuccess: ${response.isSuccess}");
      log("Response data type: ${response.responseData.runtimeType}");

      if (response.isSuccess && response.responseData != null) {
        log("Raw API response: ${response.responseData}");

        Map<String, dynamic> jsonData;

        if (response.responseData is String) {
          jsonData = json.decode(response.responseData);
        } else if (response.responseData is Map<String, dynamic>) {
          jsonData = response.responseData;
        } else {
          throw Exception(
            "Unexpected response type: ${response.responseData.runtimeType}",
          );
        }

        log("Parsed JSON data keys: ${jsonData.keys.toList()}");

        final postResult = PostInfoResult.fromJson(jsonData);
        postInfo.value = postResult;

        log("SUCCESS! Post parsed: ${postResult..content}");
        log("Total posts: ${postResult.commentGroupPost.length}");

        if (postResult.commentGroupPost.isNotEmpty) {
          log("First post by: ${postResult.commentGroupPost[0].user.firstName}");
        }
      } else {
        log("API call failed or returned null data");
        groupInfo.value = null;
      }

    }
    catch(e){
      if (Get.isDialogOpen ?? false) Get.back();

      // Show error message
      CustomSnackBar.error(title: "Error", message: "An error occurred while creating the post");


    }

    finally{
      isLoading.value = false;
    }

  }

   /// reply comment
  /// reply comment
  Future<void> createReply(String commentId, String postId) async {
    if (replyController.text.trim().isEmpty) {

      return;
    }

    isLoading.value = true;
    String? token = helper.getString("userToken");
    log("token during reply comment: $token");

    try {
      var response = await networkCaller.postRequest(
        AppUrls.replyComment(commentId),
        body: {"replyComment": replyController.text.trim()},
        token: token,
      );

      if (response.isSuccess) {
        log("Reply created: ${response.responseData}");



        // Clear reply field
        replyController.clear();

        // Close reply bottom sheet
        Get.back();

        // Refresh post information to show new reply
        await getPostInformation(postId);
      }
    } catch (e) {
      log("Error creating reply: ${e.toString()}");


    } finally {
      isLoading.value = false;
    }
  }
  

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
      CustomSnackBar.error(title: "Error", message: "Failed to capture image");


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
      CustomSnackBar.error(title: "Error", message: "Failed to select image");

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


}
