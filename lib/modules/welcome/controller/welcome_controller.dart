import 'package:chat_app/core/constants/preferences.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeController extends GetxController {
  static WelcomeController get to => Get.find();
  TextEditingController nameController = TextEditingController();
  RxBool isCameraStatus = false.obs;
  RxBool isMicroPhoneStatus = false.obs;
  RxBool isAddUser = false.obs;

  @override
  void onInit() {
    super.onInit();
    isCameraStatus.value = AppPreference.getBoolean("isCameraStatus");
    isMicroPhoneStatus.value = AppPreference.getBoolean("isMicroPhoneStatus");
  }

  RxString docId = "".obs;
  // Rx<UserModel> userModel = UserModel().obs;
  Future<void> addUserData() async {
    try {
      String deviceId = Get.arguments.toString();

      isAddUser.value = true;
      docId.value =
          FirebaseHelper.collectionReference.collection('UserData').doc().id;

      OnBodingController.to.userModel.value = UserModel(
          fullName: nameController.text,
          uid: docId.value,
          uniqueDeviceId: deviceId,
          // status: "",
          imageUrl:
              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png");
      await FirebaseHelper.collectionReference
          .collection('UserData')
          .doc(docId.value.toString())
          .set(OnBodingController.to.userModel.value.toMap());
      clearController();
      isAddUser.value = false;
      if (isCameraStatus.value && isMicroPhoneStatus.value) {
        //Navigation.popAndPushNamed(Routes.dashboardScreen);
        Navigation.replaceAll(Routes.dashboardScreen);
      } else {
        Navigation.popAndPushNamed(Routes.permissionScreen);
      }
    } catch (e) {
      isAddUser.value = false;
    }
  }

  clearController() {
    nameController.clear();
  }
}
