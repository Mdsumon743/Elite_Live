
import 'package:elites_live/core/global_widget/custom_loading.dart';
import 'package:elites_live/core/global_widget/custom_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/search_controller.dart';


class UserTabWidget extends StatelessWidget {
  UserTabWidget({super.key});

  final controller = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            'User',
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),


          // Loading State
          if (controller.isLoading.value)
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 40.h),
                child: CustomLoading(
                  color: AppColors.primaryColor,
                ),
              ),
            )

          // Error State


          // Empty State
          else if (controller.othersList.isEmpty)
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 40.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 48.sp,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No users found',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            // Success State - User List
            else
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.othersList.length,
                itemBuilder: (context, index) {
                  final otherUser = controller.othersList[index];
                  final firstName = otherUser.firstName;
                  final lastName = otherUser.lastName;
                  final userName = "$firstName $lastName";
                  return UserCard(
                    profession: otherUser.profession??'N/A',
                    imagePath: otherUser.profileImage ?? '',
                    name: userName,
                    followerCount: otherUser.totalFollowers.toString(),
                    onTap: (){
                      controller.followUnFlow(otherUser.id);
                    },

                  );
                },
              ),
        ],
      );
    });
  }
}

class UserCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final VoidCallback onTap;
  final String followerCount;
  final String profession;

  const UserCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.onTap,
    required this.followerCount,
    required this.profession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      margin: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Avatar with Shadow
          Container(
            height: 56.h,
            width: 56.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: imagePath.isNotEmpty
                  ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholderAvatar(),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _loadingAvatar();
                },
              )
                  : _placeholderAvatar(),
            ),
          ),

          SizedBox(width: 14.w),

          /// Expanded section prevents overflow
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                CustomTextView(
                 text:  name,

                  overflow: TextOverflow.ellipsis,

                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,

                ),

                SizedBox(height: 4.h),

                /// Profession + Followers Row
                Row(
                  children: [
                    /// Profession (always full)
                    Expanded(
                      child: CustomTextView(
                       text:  profession,


                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBody,

                      ),
                    ),

                    SizedBox(width: 5.w),

                    /// Divider
                    Text(
                      "|",
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    SizedBox(width: 12.w),

                    /// Followers — fixed minimum width so it never squeezes profession
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        maxWidth: 80.w,
                      ),
                      child: CustomTextView(
                      text:   followerCount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,

                      ),
                    ),
                  ],
                )

              ],
            ),
          ),

          SizedBox(width: 10.w),

          /// Follow Button
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: 36.h,
              width: 84.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Text(
                "Follow",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Loading avatar
  Widget _loadingAvatar() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: SizedBox(
          height: 16.h,
          width: 16.h,
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  /// Placeholder avatar
  Widget _placeholderAvatar() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        size: 30.sp,
        color: Colors.grey.shade600,
      ),
    );
  }
}


