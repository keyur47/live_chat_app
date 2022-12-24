import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldWidget(
        appBarTitle: AppStrings.favoriteUsers,
        leading: false,
        leadingChild: const SizedBox(),

        /// favorite user list
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeUtils.verticalBlockSize = 10,
              vertical: SizeUtils.verticalBlockSize = 10),
          child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    radius: SizeUtils.horizontalBlockSize * 7,
                    backgroundImage: const AssetImage(
                      AssetsPath.profileImage,
                    ),
                  ),
                  title: AppText(
                    title: "Alisa Bowes",
                    fontSize: SizeUtils.fSize_16(),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                  trailing: AppText(
                    title: "Today",
                    fontSize: SizeUtils.fSize_15(),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withOpacity(0.60),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: AppColors.grey,
                  height: 20,
                  indent: 13,
                  endIndent: 13,
                  thickness: 1,
                );
              },
              itemCount: 50),
        ),
      ),
    );
  }
}
