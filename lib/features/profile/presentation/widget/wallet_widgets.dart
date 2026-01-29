import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/wallet_controller.dart';

class WalletHeaderCard extends StatelessWidget {
  final WalletController controller;
  final VoidCallback? onTap;
  final String? stripeAccountId;

  const WalletHeaderCard({
    super.key,
    required this.controller,
    this.onTap,
    required this.stripeAccountId,
  });

  @override
  Widget build(BuildContext context) {
    bool hasStripeAccount =
        stripeAccountId != null && stripeAccountId!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Total Earning',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8.h),

          Obx(() => Text(
            '\$${controller.totalEarning.value.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          )),
          SizedBox(height: 16.h),

          // 🔥 Show button only if stripeAccountId is empty
          if (!hasStripeAccount)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Text(
                  'Add Money  \$+',
                  style: TextStyle(
                    color: const Color(0xFF673AB7),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

