import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final bool leading;
  final String? appBarTitle;
  final Color? appBarColor;
  final Widget? leadingChild;
  final Widget? appBarTitleWidget;
  final List<Widget>? actions;

  const CustomAppBar(
      {Key? key,
      this.leading = false,
      this.appBarTitle,
      this.appBarColor,
      this.leadingChild,
      this.appBarTitleWidget,
      this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: SizeUtils.verticalBlockSize * 2.5,
        bottom: SizeUtils.verticalBlockSize * 2.5,
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: SizeUtils.verticalBlockSize * 2),
        child: AppBar(
          leading: leading ? leadingChild : null,
          backgroundColor: AppColors.buttonColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: appBarTitleWidget ??
              Text(
                appBarTitle ?? '',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtils.fSize_24(),
                ),
              ),
          actions: actions,
        ),
      ),
    );
  }
}
