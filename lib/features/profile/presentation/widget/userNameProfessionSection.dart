import 'package:elites_live/features/profile/presentation/widget/profile_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../core/global_widget/custombuttonwhite.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../routes/app_routing.dart';

class UserNameProfessionSection extends StatelessWidget {
  const UserNameProfessionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 160.h),
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 60.h), // for profile image overlap
          Text(
            'Jolie Topley',
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF2D2D2D),
            ),
          ),
          Text(
            'Professional Model',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: Color(0xFF636F85),
            ),
          ),
          SizedBox(height: 24.h),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text("468k",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color(0xff191919),
                  ),),

                  Text("Followers",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.textColor,
                  ),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0,right: 24),
                child: Container(height: 46.h, width: 1.w, color: Color(0xFFF0F0F0)),
              ),

              Column(
                children: [
                  Text("356",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color(0xff191919),
                  ),),

                  Text("Following",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.textColor,
                  ),)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0,right: 24),
                child: Container(height: 46.h, width: 1.w, color: Color(0xFFF0F0F0)),
              ),


              Column(
                children: [
                  Text("200",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                    color: Color(0xff191919),
                  ),),

                  Text("Posts",style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColors.textColor,
                  ),)
                ],
              ),

            ],
          ),
          SizedBox(height: 24.h,),
          CustomButtonWhite(
            text:'Edit Profile',
            onPressed: (){
              Get.toNamed(AppRoute.editProfile);
            },
          ),
          SizedBox(height: 15.h),

          ProfileTabsWidget(),

          // SizedBox(height: 200.h),

        ],
      ),
    );
  }
}