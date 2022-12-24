import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/icon_button.dart';
import 'package:chat_app/core/widgets/image_text_container.dart';
import 'package:chat_app/modules/call/controller/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchingScreen extends StatelessWidget {
  SearchingScreen({Key? key}) : super(key: key);
  final CallController _callController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: SizeUtils.screenHeight,
        width: SizeUtils.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const [0.1, 0.6, 0.9],
            tileMode: TileMode.repeated,
            colors: <Color>[
              AppColors.gradientDarkBlue.withOpacity(0.90),
              AppColors.gradientMiddleBlue.withOpacity(0.75),
              AppColors.gradientLightBlue.withOpacity(0.70),
            ],
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: SizeUtils.horizontalBlockSize * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: ImageTextContainer(
                  width: SizeUtils.horizontalBlockSize * 25,
                  height: SizeUtils.horizontalBlockSize * 10,
                  text: _callController.onlineUserList.length.toString(),
                ),
              ),
              Center(
                child: Image.asset(
                  AssetsPath.worldImage,
                  scale: 5,
                ),
              ),
              Column(
                children: [
                  Container(
                    height: SizeUtils.horizontalBlockSize * 35,
                    decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Padding(
                      padding:
                          EdgeInsets.all(SizeUtils.horizontalBlockSize * 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            AssetsPath.searchingImage,
                            scale: 5,
                          ),
                          IconButtonWidget(
                            onTap: () {
                              Navigation.pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: AppColors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
