
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomTextField extends StatelessWidget {
  final String? hintText;
  final bool isReadonly;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction; // <-- added
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.hintText,
    this.validator,
    this.controller,
    this.isReadonly = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction,   // <-- added
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,   // <-- added
      readOnly: isReadonly,
      onFieldSubmitted: onSubmitted,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF9F9FB),
        hintText: hintText,
        hintStyle: GoogleFonts.andika(
          color: const Color(0xFF9BA4B0),
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        errorStyle: GoogleFonts.andika(
          color: Colors.red,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        suffixIcon: controller != null && controller!.text.isNotEmpty
            ? IconButton(
          icon: Icon(Icons.clear, size: 20.sp),
          onPressed: () {
            controller!.clear();
            if (onSubmitted != null) {
              onSubmitted!('');
            }
          },
        )
            : SizedBox.shrink(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFEDEEF4), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFEDEEF4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFB0B0B0), width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
      style: GoogleFonts.andika(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    );
  }
}




