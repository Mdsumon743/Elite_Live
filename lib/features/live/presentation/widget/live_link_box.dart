import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LinkBox extends StatelessWidget {
  final String title;
  final String value;
  final String? liveId;

  const LinkBox({
    super.key,
    required this.title,
    required this.value,
    this.liveId,
  });

  @override
  Widget build(BuildContext context) {
    String displayValue = value;

    // Apply logic for Audience Join Link
    if (title == "Audience Join Link" && liveId != null && liveId!.isNotEmpty) {
      displayValue = "$liveId|$value";
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: displayValue));
                  Get.snackbar(
                    "Copied",
                    "$title copied to clipboard",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    duration: Duration(seconds: 2),
                  );
                },
                child: Icon(
                  Icons.copy,
                  color: Colors.blue,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}