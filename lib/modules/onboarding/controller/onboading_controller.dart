import 'dart:io';

import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBodingController extends GetxController {
  static OnBodingController get to => Get.find();
  Rx<UserModel> userModel = UserModel().obs;
  Future<String> getUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();
    String uniqueDeviceId = '';
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId =
          '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}';
      // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId = '${androidDeviceInfo.model}:${androidDeviceInfo.id}';
      // unique ID on Android
    }

    debugPrint("uniqueDeviceId--$uniqueDeviceId");
    return uniqueDeviceId;
  }

  RxBool isAvailable = false.obs;
  RxBool isLoading = false.obs;
  Future<void> getUserDeviceId() async {
    try {
      isLoading.value = true;
      print("lading value is---${isLoading.value}");
      String deviceId = await getUniqueDeviceId();

      FirebaseHelper.collectionReference
          .collection('UserData')
          .get()
          .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
          Map<dynamic, dynamic> data = result.data();
          userModel.value = UserModel.fromMap(data as Map<String, dynamic>);
          if (userModel.value.uniqueDeviceId == deviceId) {
            isAvailable.value = true;
            debugPrint("yes device id available");

            Navigation.replaceAll(Routes.dashboardScreen);
            break;
          }
        }
        if (!isAvailable.value) {
          Navigation.replaceAll(Routes.welcomeScreen, arg: deviceId);
        }
      });
    } catch (e, st) {
      isAvailable.value = false;
      debugPrint(
          "----------error in login Controller GetData()------------$e,$st");
    } finally {
      isLoading.value = false;
      print("lading value is---${isLoading.value}");
    }
  }
}
