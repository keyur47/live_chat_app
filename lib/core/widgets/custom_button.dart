import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final Color color;
  final Color? textColor;
  final Color? borderColor;
  final String text;
  final double? height;
  final FontWeight fontWeight;
  final double? fontSize;

  const CustomButton(
      {Key? key,
      required this.onTap,
      required this.color,
      this.textColor,
      this.borderColor,
      this.height,
      this.fontWeight = FontWeight.w700,
      this.fontSize,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? SizeUtils.horizontalBlockSize * 12,
        width: double.infinity,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor ?? Colors.transparent)),
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(vertical: 2.5.h),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? AppColors.white,
            fontSize: fontSize ?? SizeUtils.fSize_18(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
