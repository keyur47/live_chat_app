import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/image_text_container.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:chat_app/modules/call/controller/call_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/utills/size_utils.dart';

class OnlineScreen extends StatelessWidget {
  OnlineScreen({Key? key}) : super(key: key);
  final CallController _callController = Get.find();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.buttonColor,
    ));
    return SafeArea(
      child: ScaffoldWidget(
        appBarTitle: AppStrings.online,
        leading: false,

        /// code for total online user
        actions: [
          Padding(
            padding: EdgeInsets.all(SizeUtils.verticalBlockSize * 1),
            child: ImageTextContainer(
              width: SizeUtils.horizontalBlockSize * 28,
              height: SizeUtils.horizontalBlockSize * 10,
              color: AppColors.skyLight.withOpacity(0.20),
              text: _callController.onlineUserList.length.toString(),
            ),
          )
        ],
        child: Padding(
          padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 6),
          child: SizedBox(
            width: double.infinity,
            child: _callController.onlineUserList.isNotEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: SizeUtils.horizontalBlockSize * 5,
                        mainAxisSpacing: SizeUtils.horizontalBlockSize * 5),
                    itemCount: _callController.onlineUserList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeUtils.horizontalBlockSize * 4),
                          image: DecorationImage(
                            image: NetworkImage(_callController
                                .onlineUserList[index].imageUrl
                                .toString()),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: AppText(
                              title: _callController
                                      .onlineUserList[index].fullName ??
                                  "",
                              fontSize: SizeUtils.fSize_16(),
                              color: AppColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    })
                : Center(
                    child: AppText(
                      title: "No Any User Online",
                      fontWeight: FontWeight.w600,
                      fontSize: SizeUtils.fSize_20(),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
