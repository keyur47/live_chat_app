import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget(
      {Key? key,
      this.onTap,
      this.buttonColor,
      this.height,
      this.width,
      this.child})
      : super(key: key);
  final void Function()? onTap;
  final double? width;
  final double? height;
  final Widget? child;
  final Color? buttonColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: height ?? SizeUtils.horizontalBlockSize * 10,
            width: width ?? SizeUtils.horizontalBlockSize * 10,
            decoration: BoxDecoration(
              color: buttonColor ?? AppColors.buttonColor,
              shape: BoxShape.circle,
            ),
            child: child));
  }
}
