import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/core/widgets/loader_view.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnBodingScreen extends StatelessWidget {
  OnBodingScreen({Key? key}) : super(key: key);
  final OnBodingController _onBodingController = Get.find();

  @override
  Widget build(BuildContext context) {
    SizeUtils().init(context);
    // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //   statusBarColor: AppColors.buttonColor,
    // ));
    return Scaffold(
        backgroundColor: AppColors.buttonColor,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeUtils.verticalBlockSize * 5),
                    child: Center(
                      child: Image.asset(
                        AssetsPath.onBodingImage,
                      ),
                    ),
                  ),
                  const Spacer(),
                  AppText(
                    height: 1.5,
                    title: AppStrings.itEasyTaking,
                    softWrap: true,
                    fontSize: SizeUtils.fSize_30(),
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeUtils.horizontalBlockSize * 8,
                        bottom: SizeUtils.horizontalBlockSize * 3),
                    child: AppText(
                      title: AppStrings.callYourFriend,
                      softWrap: true,
                      fontSize: SizeUtils.fSize_16(),
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                      maxLines: 3,
                    ),
                  ),
                  CustomButton(
                    height: SizeUtils.horizontalBlockSize * 14,
                    text: AppStrings.getStarted,
                    onTap: () async {
                      print("on button tap");
                      await _onBodingController.getUserDeviceId();
                    },
                    color: AppColors.white,
                    textColor: AppColors.black,
                  ),

                  /// code without loader
                  // CustomButton(
                  //   height: SizeUtils.horizontalBlockSize * 14,
                  //   text: AppStrings.getStarted,
                  //   onTap: () async {
                  //     await _onBodingController.getUserDeviceId();
                  //   },
                  //   color: AppColors.white,
                  //   textColor: AppColors.black,
                  // )
                ],
              ),
            ),
            Obx(() => _onBodingController.isLoading.value
                ? const LoaderView()
                : const SizedBox())
          ],
        ));
  }
}
