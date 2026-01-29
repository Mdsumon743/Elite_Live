import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../controller/earning_overview_controller.dart';
import '../widget/earnings_card.dart';
import '../widget/earnings_users_data.dart';

class EarningsPage extends StatelessWidget {
  EarningsPage({super.key});

  final EarningsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Gradient Header
                Container(
                  height: 190.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                  ),
                ),

                // Back Button + Title
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
                        'Earning Overview',
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content
                Container(
                  margin: EdgeInsets.only(top: 160.h),
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
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
                      // SUMMARY CARD
                      EarningsSummaryCard(),
                      SizedBox(height: 20.h),

                      // FUNDING ONLY
                      Obx(() {
                        if (controller.balanceHistory.isEmpty) {
                          return const Center(
                            child: Text("No earning data available"),
                          );
                        }

                        final fundingItems = controller.balanceHistory.first.transactionHistory
                            .map((tx) => {
                          "image": "assets/images/live1.png",
                          "title": tx.event.title,
                          "subtitle": tx.event.text,
                          "amount": "\$${tx.amount}",
                          'paymentFor': tx.paymentFor
                        })
                            .toList();

                        return EarningListCard(
                          title: "Crowdfunding",
                          items: fundingItems,
                        );
                      })

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
