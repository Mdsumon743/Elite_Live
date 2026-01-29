import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/global_widget/custom_elevated_button.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../main_view/presentation/screen/main_view_screen.dart';
import '../../controller/profile_controller.dart';
import '../../controller/wallet_controller.dart';
import '../widget/transaction_widgets.dart';
import '../widget/wallet_widgets.dart';

class WalletPage extends StatelessWidget {
   WalletPage({super.key});
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    log("the stripe id is ${profileController.userinfo.value!.stripeAccountId}");
    final controller = Get.put(WalletController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // 🔹 Gradient header
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),

                // 🔹 Back button + Title
                Positioned(
                  top: 50.h,
                  left: 20.w,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        'Wallet',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Main content
                Container(
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🟣 Wallet Header Card
                      WalletHeaderCard(
                        controller: controller,
                        stripeAccountId: profileController.userinfo.value?.stripeAccountId,
                        onTap: () {
                          controller.connectedAccountSetUp();
                        },
                      ),

                      SizedBox(height: 24.h),

                      // 🧾 Transaction History Section
                      Text(
                        'Transaction History',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      Obx(
                            () => Column(
                          children: controller.transactions
                              .map(
                                (tx) => TransactionItem(
                              title: tx['title'],
                              date: tx['date'],
                              amount: tx['amount'],
                            ),
                          )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // 🟢 Add Money Button (Optional, if you want to match your custom button)
                      CustomElevatedButton(
                    ontap: (){Get.to(()=> MainViewScreen());},
                        text: "Done",
                        textStyle: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white
                        ),
                      ),
                    ],
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
