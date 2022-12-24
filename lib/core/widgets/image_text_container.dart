import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:flutter/material.dart';

class ImageTextContainer extends StatelessWidget {
  const ImageTextContainer(
      {Key? key, this.width, this.height, this.color, this.text, this.radius})
      : super(key: key);
  final Color? color;
  final double? radius;
  final double? width;
  final double? height;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? SizeUtils.horizontalBlockSize * 25,
      height: height ?? SizeUtils.horizontalBlockSize * 10,
      decoration: BoxDecoration(
          color: color ?? AppColors.lightBlue,
          borderRadius: BorderRadius.circular(radius ?? 20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            AssetsPath.internetIcon,
            scale: 4,
            color: AppColors.white,
          ),
          AppText(
            title: text ?? "0",
            fontSize: SizeUtils.fSize_20(),
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          )
        ],
      ),
    );
  }
}
