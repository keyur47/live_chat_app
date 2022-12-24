import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/constants/preferences.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/modules/welcome/controller/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatelessWidget {
  PermissionScreen({Key? key}) : super(key: key);
  final WelcomeController _welcomeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: SizeUtils.horizontalBlockSize * 8,
                      bottom: SizeUtils.horizontalBlockSize * 2),
                  child: Container(
                    height: SizeUtils.horizontalBlockSize * 38,
                    width: SizeUtils.horizontalBlockSize * 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(AssetsPath.videoIcon),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
              ),
              Center(
                child: AppText(
                  title: AppStrings.finalStep,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtils.fSize_20(),
                ),
              ),
              SizedBox(
                height: SizeUtils.horizontalBlockSize * 3,
              ),
              Center(
                child: AppText(
                  title: AppStrings.enableMicroAndCamera,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeUtils.fSize_14(),
                ),
              ),
              Center(
                child: AppText(
                  title: AppStrings.toGet,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeUtils.fSize_14(),
                ),
              ),
              SizedBox(
                height: SizeUtils.horizontalBlockSize * 5,
              ),
              ListTile(
                onTap: () async {
                  try {
                    var statuses = await Permission.camera.request();

                    if (statuses == PermissionStatus.granted) {
                      _welcomeController.isCameraStatus.value = true;
                      AppPreference.setBoolean("isCameraStatus",
                          value: _welcomeController.isCameraStatus.value);
                    }
                    if (statuses != PermissionStatus.granted) {
                      await Permission.camera.request();
                      _welcomeController.isCameraStatus.value = true;
                      AppPreference.setBoolean("isCameraStatus",
                          value: _welcomeController.isCameraStatus.value);
                    }
                    if (_welcomeController.isCameraStatus.value &&
                        _welcomeController.isMicroPhoneStatus.value) {
                      _ageVerifyPopup1();
                    }
                  } catch (e) {
                    print("error access to get camera permition--$e");
                  }
                },
                minLeadingWidth: SizeUtils.horizontalBlockSize * 3,
                leading: SizedBox(
                  height: SizeUtils.horizontalBlockSize * 7,
                  width: SizeUtils.horizontalBlockSize * 7,
                  child: Image.asset(
                    AssetsPath.cameraIcon,
                    fit: BoxFit.fill,
                  ),
                ),
                title: AppText(
                  title: AppStrings.camera,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeUtils.fSize_16(),
                  color: AppColors.black,
                ),
                subtitle: AppText(
                  title: AppStrings.videoCall,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeUtils.fSize_14(),
                  color: AppColors.black,
                ),
                trailing: SizedBox(
                    height: SizeUtils.horizontalBlockSize * 7,
                    width: SizeUtils.horizontalBlockSize * 7,
                    child: Obx(
                      () => _welcomeController.isCameraStatus.value
                          ? Image.asset(
                              AssetsPath.selectIcon,
                              fit: BoxFit.fill,
                            )
                          : Image.asset(
                              AssetsPath.roundIcon,
                              fit: BoxFit.fill,
                            ),
                    )),
              ),
              ListTile(
                onTap: () async {
                  try {
                    PermissionStatus statuses =
                        await Permission.microphone.request();

                    debugPrint("status of microphone---$statuses");
                    if (statuses == PermissionStatus.granted) {
                      _welcomeController.isMicroPhoneStatus.value = true;
                      AppPreference.setBoolean("isMicroPhoneStatus",
                          value: _welcomeController.isMicroPhoneStatus.value);
                    }
                    if (statuses != PermissionStatus.granted) {
                      await Permission.microphone.request();
                      _welcomeController.isMicroPhoneStatus.value = true;
                      AppPreference.setBoolean("isMicroPhoneStatus",
                          value: _welcomeController.isMicroPhoneStatus.value);
                    }
                    if (_welcomeController.isCameraStatus.value &&
                        _welcomeController.isMicroPhoneStatus.value) {
                      await _ageVerifyPopup1();
                    }
                  } catch (e) {
                    debugPrint("error access to get camera permission--$e");
                  }
                },
                minLeadingWidth: SizeUtils.horizontalBlockSize * 3,
                leading: SizedBox(
                  height: SizeUtils.horizontalBlockSize * 7,
                  width: SizeUtils.horizontalBlockSize * 7,
                  child: Image.asset(
                    AssetsPath.microphoneIcon,
                    fit: BoxFit.fill,
                  ),
                ),
                title: AppText(
                  title: AppStrings.microphone,
                  fontWeight: FontWeight.w700,
                  fontSize: SizeUtils.fSize_16(),
                  color: AppColors.black,
                ),
                subtitle: AppText(
                  title: AppStrings.voiceCall,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeUtils.fSize_14(),
                  color: AppColors.black,
                ),
                trailing: SizedBox(
                  height: SizeUtils.horizontalBlockSize * 7,
                  width: SizeUtils.horizontalBlockSize * 7,
                  child: Obx(
                    () => _welcomeController.isMicroPhoneStatus.value
                        ? Image.asset(
                            AssetsPath.selectIcon,
                            fit: BoxFit.fill,
                          )
                        : Image.asset(
                            AssetsPath.roundIcon,
                            fit: BoxFit.fill,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _ageVerifyPopup1() async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeUtils.verticalBlockSize * 2))),
          insetPadding: EdgeInsets.all(SizeUtils.verticalBlockSize * 0),
          contentPadding: EdgeInsets.all(SizeUtils.verticalBlockSize * 2),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: SizeUtils.horizontalBlockSize * 7,
                  width: SizeUtils.horizontalBlockSize * 55,
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.buttonColor),
                      borderRadius: BorderRadius.circular(
                          SizeUtils.verticalBlockSize * 2)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeUtils.horizontalBlockSize * 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.not_interested_rounded,
                          size: SizeUtils.verticalBlockSize * 2.5,
                          color: AppColors.buttonColor,
                        ),
                        SizedBox(
                          width: SizeUtils.horizontalBlockSize * 1.5,
                        ),
                        AppText(
                          title: AppStrings.policy,
                          fontWeight: FontWeight.w500,
                          fontSize: SizeUtils.fSize_14(),
                          color: AppColors.buttonColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeUtils.verticalBlockSize * 1.5,
              ),
              SizedBox(
                  height: SizeUtils.horizontalBlockSize * 11,
                  width: SizeUtils.horizontalBlockSize * 11,
                  child: Image.asset(AssetsPath.age18)),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeUtils.horizontalBlockSize * 2.5),
                child: AppText(
                  title: AppStrings.ageVerification,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeUtils.fSize_25(),
                  color: AppColors.buttonColor,
                ),
              ),
              AppText(
                title: AppStrings.youMustBe,
                fontWeight: FontWeight.w400,
                fontSize: SizeUtils.fSize_14(),
                color: AppColors.black,
              ),
              AppText(
                title: AppStrings.toEnter,
                fontWeight: FontWeight.w400,
                fontSize: SizeUtils.fSize_14(),
                color: AppColors.black,
              ),
            ],
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 2),
              child: CustomButton(
                height: SizeUtils.horizontalBlockSize * 12,
                text: AppStrings.iam18,
                fontSize: SizeUtils.fSize_14(),
                fontWeight: FontWeight.w500,
                onTap: () {
                  _ageVerifyPopup2(context);
                },
                color: AppColors.buttonColor,
                textColor: AppColors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  _ageVerifyPopup2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(SizeUtils.verticalBlockSize * 2))),
          insetPadding: EdgeInsets.all(SizeUtils.verticalBlockSize * 3),
          contentPadding: EdgeInsets.all(SizeUtils.verticalBlockSize * 2),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: SizeUtils.horizontalBlockSize * 18,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AssetsPath.warningImage),
                        fit: BoxFit.fill)),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: SizeUtils.horizontalBlockSize * 3),
                child: SizedBox(child: Image.asset(AssetsPath.warningImage2)),
              ),
              SizedBox(height: SizeUtils.verticalBlockSize * 3.5),
              CustomButton(
                height: SizeUtils.horizontalBlockSize * 12,
                text: AppStrings.iUnderstand,
                onTap: () {
                  Navigation.replaceAll(Routes.dashboardScreen);
                },
                fontSize: SizeUtils.fSize_14(),
                fontWeight: FontWeight.w500,
                color: AppColors.buttonColor,
                textColor: AppColors.white,
              )
            ],
          ),
        );
      },
    );
  }
}
