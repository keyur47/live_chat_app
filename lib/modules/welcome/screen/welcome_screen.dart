import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/utills/keyboard.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/core/widgets/custom_textfield.dart';
import 'package:chat_app/core/widgets/loader_view.dart';
import 'package:chat_app/modules/welcome/controller/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key, this.deviceId}) : super(key: key);
  final String? deviceId;
  final WelcomeController _welcomeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.white,
        body: Obx(
          () => Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 8),
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeUtils.horizontalBlockSize * 10),
                        child: Container(
                          height: SizeUtils.horizontalBlockSize * 30,
                          width: SizeUtils.horizontalBlockSize * 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(AssetsPath.personIcon),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: AppText(
                        title: AppStrings.welcome,
                        color: AppColors.black,
                        fontSize: SizeUtils.fSize_20(),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: SizeUtils.horizontalBlockSize * 6,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: _welcomeController.nameController,
                      hintText: AppStrings.name,
                      maxLine: 1,
                    ),
                    const Spacer(),
                    CustomButton(
                      height: SizeUtils.horizontalBlockSize * 14,
                      text: AppStrings.continue1,
                      onTap: () async {
                        KeyboardUtils.hideKeyboard(context);
                        await _welcomeController.addUserData();
                      },
                      color: AppColors.buttonColor,
                      textColor: AppColors.white,
                    ),
                  ],
                ),
              ),
              _welcomeController.isAddUser.value
                  ? const LoaderView()
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
