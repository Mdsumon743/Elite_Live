import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.title,
    this.isGroup = false,
    this.onTap,
  });

  final bool isGroup;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF591AD4), Color(0xFFC121A0)],
    );

    return GestureDetector(
      onTap: () {
        log("🔘 GradientButton tapped: $title");
        if (onTap != null) {
          onTap!(); // ✅ Execute the callback
        } else {
          log("⚠️ No onTap callback provided");
        }
      },
      child: Container(
        padding: EdgeInsets.all(1.5.w),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              if (isGroup)
                ShaderMask(
                  shaderCallback: (bounds) => gradient.createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
                  child: Icon(
                    Icons.group_add,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
