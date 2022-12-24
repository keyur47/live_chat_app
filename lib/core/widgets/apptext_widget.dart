import 'package:chat_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({
    Key? key,
    required this.title,
    this.maxLines,
    this.fontWeight,
    this.fontSize,
    this.color,
    this.height,
    this.letterSpacing,
    this.softWrap,
    this.wordSpacing,
    this.textAlign,
    this.textOverflow,
  }) : super(key: key);

  final String title;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final double? height;
  final double? letterSpacing;
  final bool? softWrap;
  final double? wordSpacing;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softWrap,
      maxLines: maxLines ?? 5,
      textAlign: textAlign,
      style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.w600,
          fontSize: fontSize ?? 14,
          color: color ?? AppColors.black,
          height: height,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          overflow: textOverflow),
    );
  }
}
