import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? textFieldLabel;
  final bool isPassword;
  final String? Function(String?)? validator;
  const MyTextFormField({
    this.validator,
    super.key,
    this.isPassword = false,
    this.textFieldLabel,
    this.controller,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textFieldLabel ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          validator: validator,
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 12.sp,
              letterSpacing: 2,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
