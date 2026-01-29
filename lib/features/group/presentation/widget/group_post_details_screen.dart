import 'dart:developer';
import 'dart:io';
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/features/group/controller/group_post_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/global_widget/custom_text_view.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../../home/controller/home_controller.dart';
import '../../../home/data/comment_data_model.dart';
import '../../../home/presentation/widget/comment_input_box.dart';
import '../../../home/presentation/widget/share_sheet.dart';
import '../../data/group_info_data_model.dart';
import '../../data/post_info_data_model.dart';
class GroupPostDetailsSection extends StatelessWidget {
   GroupPostDetailsSection({
    super.key,
    required this.replyingToId,
     required this.groupId,
    required this.replyingToName,
    required this.controller,
    required this.groupPosts, // Added parameter
  });

  final RxString replyingToId;
  final String groupId;
  final RxString replyingToName;
  final HomeController controller;
  final List<GroupPost> groupPosts; // Added parameter
   final GroupPostController groupPostController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Loop through all group posts
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupPosts.length,
          itemBuilder: (context, index) {
            final post = groupPosts[index];
            return _buildPostCard(context, post);
          },
        ),
      ],
    );
  }

  Widget _buildPostCard(BuildContext context, GroupPost post) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.r),
        border: Border.all(width: 1.w, color: Color(0xFFEDEEF4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post Header (User Info)
          Row(
            children: [
              CircleAvatar(
                backgroundImage: post.user.profileImage != null
                    ? NetworkImage(post.user.profileImage??"")
                    : AssetImage(ImagePath.dance) as ImageProvider,
                radius: 20.r,
              ),
              SizedBox(width: 7.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextView(
                      text: "${post.user.firstName} ${post.user.lastName}",
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHeader,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        CustomTextView(
                          text: _formatDate(post.createdAt),
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: AppColors.textBody,
                        ),
                        SizedBox(width: 4.w),
                        Image.asset(
                          ImagePath.dotIndicator,
                          height: 10.h,
                          width: 10.w,
                        ),
                        SizedBox(width: 4.w),
                        CustomTextView(
                          text: _formatTime(post.createdAt),
                          fontWeight: FontWeight.w400,
                          fontSize: 10.sp,
                          color: AppColors.textBody,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Show options menu only if user is post owner
              if (post.isOwner)
                PopupMenuButton<int>(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  color: Colors.white,
                  elevation: 8,
                  offset: Offset(0, 8.h),
                  icon: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      size: 20.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  itemBuilder: (context) => [
                    // Edit Option
                    PopupMenuItem(
                      value: 1,
                      height: 48.h,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 18.sp,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textHeader,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    PopupMenuItem(
                      enabled: false,
                      height: 1,
                      padding: EdgeInsets.zero,
                      child: Divider(height: 1, thickness: 1),
                    ),

                    // Delete Option
                    PopupMenuItem(
                      value: 2,
                      height: 48.h,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18.sp,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 1) {
                      log("Edit post: ${post.id}");
                      //_showEditPostBottomSheet(context, post);
                    } else if (value == 2) {
                      log("Delete post: ${post.id}");
                      _showDeletePostConfirmation(context, post.id);
                    }
                  },
                ),
            ],
          ),
          SizedBox(height: 24.h),

          // Post Content
          CustomTextView(
            text: post.content,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),
          SizedBox(height: 20.h),

          // Post Actions (Like, Comment, Share)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Like Button
              GestureDetector(
                onTap: () {
                  groupPostController.likePost(post.id);
                  ///log("Like post: ${post.id}");
                  // Add like/unlike logic
                },
                child: Row(
                  children: [
                    Icon(
                      post.isLike ? Icons.favorite : Icons.favorite_outline,
                      color: post.isLike ? Colors.red : Colors.grey,
                      size: 20.sp,
                    ),
                    SizedBox(width: 4.w),
                    CustomTextView(
                      text: _formatCount(post.count.likeGroupPost),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader,
                    ),
                  ],
                ),
              ),

              // Comment Button
              GestureDetector(
                onTap: () {
                  _showPostCommentsBottomSheet(context, post.id);

                  log("View comments for post: ${post.id}");

                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.comment, size: 18.sp),
                    SizedBox(width: 4.w),
                    CustomTextView(
                      text: _formatCount(post.count.commentGroupPost),
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader,
                    ),
                  ],
                ),
              ),

              // Share Button
              GestureDetector(
                onTap: () {
                  ShareSheet().show(context);
                },
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.share, size: 18.sp),
                    SizedBox(width: 4.w),
                    CustomTextView(
                      text: "Share",
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      color: AppColors.textHeader,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Reply indicator
          Obx(() => replyingToId.value.isNotEmpty
              ? Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Replying to ${replyingToName.value}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    replyingToId.value = '';
                    replyingToName.value = '';
                  },
                )
              ],
            ),
          )
              : SizedBox.shrink()),

          // Comments Section (if you want to show comments here)
          Obx(() => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.comments.length,
            itemBuilder: (context, index) {
              final comment = controller.comments[index];
              return _buildCommentTile(
                comment,
                replyingToId,
                replyingToName,
                controller,
              );
            },
          )),
          SizedBox(height: 10.h),

          // Comment Input Box
          /*CommentInputBox(onTap: (){
            groupPostController.createPostComment(post.id);
          },),*/
        ],
      ),
    );
  }

  // Format date (e.g., "April 06, 2025")
  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return "${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}";
  }

  // Format time (e.g., "6:20 pm")
  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final period = date.hour >= 12 ? 'pm' : 'am';
    return "$hour:${date.minute.toString().padLeft(2, '0')} $period";
  }

  // Format count (e.g., 1000 -> "1k", 1500000 -> "1.5M")
  String _formatCount(int count) {
    if (count >= 1000000) {
      return "${(count / 1000000).toStringAsFixed(1)}M";
    } else if (count >= 1000) {
      return "${(count / 1000).toStringAsFixed(1)}k";
    }
    return count.toString();
  }

   void _showPostCommentsBottomSheet(BuildContext context, String postId) {

     groupPostController.getPostInformation(postId);

     Get.bottomSheet(
       Container(
         height: Get.height * 0.85,
         decoration: BoxDecoration(
           color: Colors.white,
           borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
         ),
         child: Column(
           children: [
             // Handle bar and header
             Container(
               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
               decoration: BoxDecoration(
                 border: Border(
                   bottom: BorderSide(color: Color(0xFFEDEEF4), width: 1.w),
                 ),
               ),
               child: Column(
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
                   SizedBox(height: 16.h),
                   // Header
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       CustomTextView(
                         text: "Comments",
                         fontSize: 18.sp,
                         fontWeight: FontWeight.w600,
                         color: AppColors.textHeader,
                       ),
                       IconButton(
                         onPressed: () => Get.back(),
                         icon: Icon(Icons.close, size: 24.sp),
                       ),
                     ],
                   ),
                 ],
               ),
             ),

             // Content area
             Expanded(
               child: Obx(() {
                 if (groupPostController.isLoading.value) {
                   return Center(
                     child: CustomLoading(
                       color: AppColors.primaryColor,
                     ),
                   );
                 }

                 final postInfo = groupPostController.postInfo.value;

                 if (postInfo == null) {
                   return Center(
                     child: CustomTextView(
                       text: "No comments yet",
                       fontSize: 14.sp,
                       color: AppColors.textBody,
                     ),
                   );
                 }

                 return SingleChildScrollView(
                   padding: EdgeInsets.all(16.w),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       // Original Post
                       _buildOriginalPost(postInfo),

                       SizedBox(height: 24.h),

                       // Comments count
                       CustomTextView(
                         text: "${postInfo.commentGroupPost.length} Comments",
                         fontSize: 16.sp,
                         fontWeight: FontWeight.w600,
                         color: AppColors.textHeader,
                       ),

                       SizedBox(height: 16.h),

                       // Comments List
                       if (postInfo.commentGroupPost.isEmpty)
                         Center(
                           child: Padding(
                             padding: EdgeInsets.symmetric(vertical: 40.h),
                             child: Column(
                               children: [
                                 Icon(
                                   FontAwesomeIcons.comment,
                                   size: 48.sp,
                                   color: Colors.grey[300],
                                 ),
                                 SizedBox(height: 16.h),
                                 CustomTextView(
                                   text: "No comments yet",
                                   fontSize: 14.sp,
                                   color: AppColors.textBody,
                                 ),
                               ],
                             ),
                           ),
                         )
                       else
                         ListView.separated(
                           shrinkWrap: true,
                           physics: NeverScrollableScrollPhysics(),
                           itemCount: postInfo.commentGroupPost.length,
                           separatorBuilder: (context, index) => Divider(
                             height: 32.h,
                             color: Color(0xFFEDEEF4),
                           ),
                           itemBuilder: (context, index) {
                             final comment = postInfo.commentGroupPost[index];
                             return _buildCommentItem(comment, postId);
                           },
                         ),
                     ],
                   ),
                 );
               }),
             ),

             // Comment Input at bottom
             Container(
               padding: EdgeInsets.all(16.w),
               decoration: BoxDecoration(
                 color: Colors.white,
                 border: Border(
                   top: BorderSide(color: Color(0xFFEDEEF4), width: 1.w),
                 ),
               ),
               child: Row(
                 children: [
                   Expanded(
                     child: TextField(
                       controller: groupPostController.commentController,
                       decoration: InputDecoration(
                         hintText: "Write a comment...",
                         hintStyle: TextStyle(
                           fontSize: 14.sp,
                           color: Colors.grey[400],
                         ),
                         filled: true,
                         fillColor: Color(0xFFF5F5F5),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(24.r),
                           borderSide: BorderSide.none,
                         ),
                         contentPadding: EdgeInsets.symmetric(
                           horizontal: 16.w,
                           vertical: 12.h,
                         ),
                       ),
                       maxLines: null,
                     ),
                   ),
                   SizedBox(width: 8.w),
                   GestureDetector(
                     onTap: () {
                       if (groupPostController.commentController.text.trim().isNotEmpty) {
                         groupPostController.createPostComment(postId);
                       }
                     },
                     child: Container(
                       padding: EdgeInsets.all(12.w),
                       decoration: BoxDecoration(
                         color: AppColors.primaryColor,
                         shape: BoxShape.circle,
                       ),
                       child: Icon(
                         Icons.send,
                         color: Colors.white,
                         size: 20.sp,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
       ),
       isScrollControlled: true,
       isDismissible: true,
       enableDrag: true,
     );
   }

   Widget _buildOriginalPost(PostInfoResult postInfo) {
     return Container(
       padding: EdgeInsets.all(16.w),
       decoration: BoxDecoration(
         color: Color(0xFFF5F5F5),
         borderRadius: BorderRadius.circular(12.r),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               CircleAvatar(
                 backgroundImage: postInfo.user.profileImage != null
                     ? NetworkImage(postInfo.user.profileImage!)
                     : AssetImage(ImagePath.dance) as ImageProvider,
                 radius: 20.r,
               ),
               SizedBox(width: 12.w),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     CustomTextView(
                       text: "${postInfo.user.firstName} ${postInfo.user.lastName}",
                       fontSize: 16.sp,
                       fontWeight: FontWeight.w600,
                       color: AppColors.textHeader,
                     ),
                     SizedBox(height: 4.h),
                     CustomTextView(
                       text: _formatDate(postInfo.createdAt),
                       fontSize: 12.sp,
                       fontWeight: FontWeight.w400,
                       color: AppColors.textBody,
                     ),
                   ],
                 ),
               ),
             ],
           ),
           SizedBox(height: 12.h),
           CustomTextView(
             text: postInfo.content,
             fontSize: 14.sp,
             fontWeight: FontWeight.w400,
             color: AppColors.textBody,
           ),
         ],
       ),
     );
   }

   Widget _buildCommentItem(CommentGroupPost comment, String postId) {
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             CircleAvatar(
               backgroundImage: AssetImage(ImagePath.dance),
               radius: 18.r,
             ),
             SizedBox(width: 12.w),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   CustomTextView(
                     text: "${comment.user.firstName} ${comment.user.lastName}",
                     fontSize: 14.sp,
                     fontWeight: FontWeight.w600,
                     color: AppColors.textHeader,
                   ),
                   SizedBox(height: 4.h),
                   if (comment.comment.isNotEmpty)
                     CustomTextView(
                       text: comment.comment,
                       fontSize: 13.sp,
                       fontWeight: FontWeight.w400,
                       color: AppColors.textBody,
                     ),
                   SizedBox(height: 8.h),
                   Row(
                     children: [
                       CustomTextView(
                         text: _getTimeAgo(comment.createdAt),
                         fontSize: 12.sp,
                         fontWeight: FontWeight.w400,
                         color: Colors.grey[500]!,
                       ),
                       SizedBox(width: 16.w),
                       GestureDetector(
                         onTap: () {
                           _showReplyBottomSheet(comment.id, comment.user.firstName, postId);
                         },
                         child: CustomTextView(
                           text: "Reply",
                           fontSize: 12.sp,
                           fontWeight: FontWeight.w500,
                           color: AppColors.primaryColor,
                         ),
                       ),
                     ],
                   ),

                   // Replies section
                   if (comment.replyCommentGroupPost.isNotEmpty) ...[
                     SizedBox(height: 12.h),
                     ...comment.replyCommentGroupPost.map((reply) =>
                         Padding(
                           padding: EdgeInsets.only(left: 32.w, top: 12.h),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               CircleAvatar(
                                 backgroundImage: AssetImage(ImagePath.dance),
                                 radius: 14.r,
                               ),
                               SizedBox(width: 8.w),
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     CustomTextView(
                                       text: "${reply.user.firstName} ${reply.user.lastName}",
                                       fontSize: 13.sp,
                                       fontWeight: FontWeight.w600,
                                       color: AppColors.textHeader,
                                     ),
                                     SizedBox(height: 4.h),
                                     CustomTextView(
                                       text: reply.replyComment,
                                       fontSize: 12.sp,
                                       fontWeight: FontWeight.w400,
                                       color: AppColors.textBody,
                                     ),
                                     SizedBox(height: 4.h),
                                     CustomTextView(
                                       text: _getTimeAgo(reply.createdAt),
                                       fontSize: 11.sp,
                                       fontWeight: FontWeight.w400,
                                       color: Colors.grey[500]!,
                                     ),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         ),
                     ),
                   ],
                 ],
               ),
             ),
           ],
         ),
       ],
     );
   }

   void _showReplyBottomSheet(String commentId, String userName, String postId) {
     Get.bottomSheet(
       Container(
         padding: EdgeInsets.all(16.w),
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
             SizedBox(height: 16.h),

             // Header
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 CustomTextView(
                   text: "Reply to $userName",
                   fontSize: 16.sp,
                   fontWeight: FontWeight.w600,
                   color: AppColors.textHeader,
                 ),
                 IconButton(
                   onPressed: () {
                     groupPostController.replyController.clear();
                     Get.back();
                   },
                   icon: Icon(Icons.close, size: 24.sp),
                 ),
               ],
             ),

             SizedBox(height: 16.h),

             // Reply Input
             Row(
               children: [
                 Expanded(
                   child: TextField(
                     controller: groupPostController.replyController,
                     decoration: InputDecoration(
                       hintText: "Write a reply...",
                       hintStyle: TextStyle(
                         fontSize: 14.sp,
                         color: Colors.grey[400],
                       ),
                       filled: true,
                       fillColor: Color(0xFFF5F5F5),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(24.r),
                         borderSide: BorderSide.none,
                       ),
                       contentPadding: EdgeInsets.symmetric(
                         horizontal: 16.w,
                         vertical: 12.h,
                       ),
                     ),
                     maxLines: null,
                     autofocus: true,
                   ),
                 ),
                 SizedBox(width: 8.w),
                 GestureDetector(
                   onTap: () {
                     if (groupPostController.replyController.text.trim().isNotEmpty) {
                       groupPostController.createReply(commentId, postId);
                     }
                   },
                   child: Container(
                     padding: EdgeInsets.all(12.w),
                     decoration: BoxDecoration(
                       color: AppColors.primaryColor,
                       shape: BoxShape.circle,
                     ),
                     child: Icon(
                       Icons.send,
                       color: Colors.white,
                       size: 20.sp,
                     ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
       isScrollControlled: true,
       isDismissible: true,
     );
   }



  /// Build Comment Tile
  Widget _buildCommentTile(
      Comment comment,
      RxString replyingToId,
      RxString replyingToName,
      HomeController controller,
      ) {
    return GestureDetector(
      onTap: () {
        replyingToId.value = comment.id;
        replyingToName.value = comment.userName;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(comment.userImage),
              radius: 20.r,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextView(
                    text: comment.userName,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                    color: AppColors.textHeader,
                  ),
                  SizedBox(height: 4.h),
                  if (comment.text.isNotEmpty)
                    CustomTextView(
                      text: comment.text,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBody,
                    ),
                  if (comment.imagePath != null)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(comment.imagePath!),
                          height: 120.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      CustomTextView(
                        text: _getTimeAgo(comment.timestamp),
                        fontWeight: FontWeight.w400,
                        fontSize: 10.sp,
                        color: AppColors.textHeader,
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () => controller.toggleLike(comment.id),
                        child: CustomTextView(
                          text: comment.isLiked.value ? "Liked" : "Like",
                          color: AppColors.textHeader,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      GestureDetector(
                        onTap: () {
                          replyingToId.value = comment.id;
                          replyingToName.value = comment.userName;
                        },
                        child: CustomTextView(
                          text: "Reply",
                          color: AppColors.textHeader,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                        ),
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

  /// Time Ago Formatter
  String _getTimeAgo(DateTime timestamp) {
    final Duration diff = DateTime.now().difference(timestamp);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

   void _showDeletePostConfirmation(BuildContext context, String postId) {
     showDialog(
       context: context,
       builder: (context) => AlertDialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(16.r),
         ),
         contentPadding: EdgeInsets.all(24.w),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             // Warning Icon
             Container(
               padding: EdgeInsets.all(16.w),
               decoration: BoxDecoration(
                 color: Colors.red.withValues(alpha: 0.1),
                 shape: BoxShape.circle,
               ),
               child: Icon(
                 Icons.delete_outline,
                 size: 48.sp,
                 color: Colors.red,
               ),
             ),
             SizedBox(height: 20.h),

             // Title
             CustomTextView(
               text: "Delete Post",
               fontSize: 20.sp,
               fontWeight: FontWeight.w600,
               color: AppColors.textHeader,
             ),
             SizedBox(height: 12.h),

             // Message
             CustomTextView(
               text: "Are you sure you want to delete this post? This action cannot be undone.",
               fontSize: 14.sp,
               fontWeight: FontWeight.w400,
               color: AppColors.textBody,
               textAlign: TextAlign.center,
             ),
             SizedBox(height: 24.h),

             // Buttons
             Row(
               children: [
                 Expanded(
                   child: CustomElevatedButton(
                     ontap: () => Get.back(),
                     text: "Cancel",
                     backgroundColor: Colors.grey[200]!,
                     textColor: AppColors.textHeader,
                   ),
                 ),
                 SizedBox(width: 12.w),
                 Expanded(
                   child: CustomElevatedButton(
                     ontap: () {
                       Get.back(); // Close dialog
                       groupPostController.deleteGroupPost(postId);
                     },
                     text: "Delete",
                     backgroundColor: Colors.red,
                     textColor: Colors.white,
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
     );
   }
}