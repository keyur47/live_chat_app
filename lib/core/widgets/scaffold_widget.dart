import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ScaffoldWidget extends StatelessWidget {
  final bool leading;
  final String? appBarTitle;
  final Color? appBarColor;
  final Widget? leadingChild;
  final Widget? appBarTitleWidget;
  final Widget? floatingButton;
  final List<Widget>? actions;
  final Widget? child;
  final bool? resizeToAvoidBottomInset;
  const ScaffoldWidget(
      {Key? key,
      this.appBarTitle,
      required this.child,
      this.leading = false,
      this.leadingChild,
      this.appBarTitleWidget,
      this.actions,
      this.appBarColor,
      this.floatingButton,
      this.resizeToAvoidBottomInset})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? false,
      backgroundColor: AppColors.buttonColor,
      body: Column(
        children: [
          CustomAppBar(
            appBarTitleWidget: appBarTitleWidget,
            appBarTitle: appBarTitle,
            appBarColor: appBarColor,
            leading: leading,
            actions: actions,
            leadingChild: leadingChild,
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
