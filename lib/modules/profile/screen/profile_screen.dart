import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/core/widgets/custom_textfield.dart';
import 'package:chat_app/core/widgets/icon_button.dart';
import 'package:chat_app/core/widgets/loader_view.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/profile/controller/profile_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key) {
    ProfileController.to.imageUral.value =
        OnBodingController.to.userModel.value.imageUrl!;

    ProfileController.to.editNameController.text =
        OnBodingController.to.userModel.value.fullName!;

    ProfileController.to.editAgeController.text =
        OnBodingController.to.userModel.value.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            ScaffoldWidget(
              appBarTitle: AppStrings.profile,
              leading: true,
              leadingChild: Padding(
                padding: EdgeInsets.all(SizeUtils.verticalBlockSize * 0.9),
                child: IconButtonWidget(
                  buttonColor: AppColors.skyLight.withOpacity(0.20),
                  onTap: () {
                    Navigation.pop();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      AssetsPath.backIcon,
                      scale: 3.5,
                    ),
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(SizeUtils.verticalBlockSize * 3),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: SizedBox(
                            height: SizeUtils.verticalBlockSize * 23,
                            width: SizeUtils.verticalBlockSize * 23,
                            child: Image.network(
                              ProfileController.to.imageUral.value,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: SizeUtils.verticalBlockSize * 1,
                            right: SizeUtils.verticalBlockSize * 2,
                            child: GestureDetector(
                              onTap: () async {
                                await ProfileController.to.pickImage();
                              },
                              child: Container(
                                  height: SizeUtils.verticalBlockSize * 5,
                                  width: SizeUtils.verticalBlockSize * 5,
                                  decoration: const BoxDecoration(
                                      color: AppColors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors.grey,
                                            blurRadius: 0.5,
                                            offset: Offset(0, 2))
                                      ]),
                                  child: const Icon(
                                    Icons.edit,
                                    color: AppColors.buttonColor,
                                  )),
                            ))
                      ],
                    ),
                    SizedBox(height: SizeUtils.verticalBlockSize * 5),
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      controller: ProfileController.to.editNameController,
                      hintText: AppStrings.name,
                      maxLine: 1,
                    ),
                    SizedBox(height: SizeUtils.verticalBlockSize * 3),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      controller: ProfileController.to.editAgeController,
                      hintText: AppStrings.age,
                      maxLine: 1,
                    ),
                    SizedBox(height: SizeUtils.verticalBlockSize * 8),
                    CustomButton(
                        onTap: () async {
                          String imagePath = "";
                          if (ProfileController.to.photo.value.isNotEmpty) {
                            imagePath = await ProfileController.to
                                .addImageStorage(
                                    ProfileController.to.photo.value);
                          }
                          UserModel userModel1 = UserModel(
                              uid: OnBodingController.to.userModel.value.uid,
                              fullName:
                                  ProfileController.to.editNameController.text,
                              age: int.parse(
                                  ProfileController.to.editAgeController.text),
                              imageUrl: imagePath);
                          ProfileController.to.updateProfile(userModel1);
                          Get.back();
                        },
                        color: AppColors.buttonColor,
                        height: SizeUtils.verticalBlockSize * 6,
                        text: AppStrings.submit)
                  ],
                ),
              ),
            ),
            ProfileController.to.isSubmit.value
                ? const LoaderView()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
