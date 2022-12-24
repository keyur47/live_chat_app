import 'dart:io';

import 'package:chat_app/core/exception/exceptions.dart';
import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();
  TextEditingController editNameController = TextEditingController();
  TextEditingController editAgeController = TextEditingController();

  RxBool isSubmit = false.obs;

  final ImagePicker _picker = ImagePicker();
  XFile? image;
  RxString photo = "".obs;
  RxString imageUral =
      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
          .obs;

  ///second profile network image
  // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_upzZ7ljAZIdBCo1AL1A3BPA5i_b2K1HI4w&usqp=CAU"

  Future<File?> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        debugPrint("photo.value--->${photo.value}");
        photo.value = image.path;
      }
    } catch (e) {
      debugPrint("error in filePickerController in pickImage()----->$e");
    }
    return null;
  }

  Future<String> addImageStorage(String url) async {
    isSubmit.value = true;
    String imageLink = await FirebaseHelper.updateProfilePic(picUrl: url);

    isSubmit.value = false;
    return imageLink;
  }

  Future<void> updateProfile(UserModel userModel) async {
    try {
      await FirebaseHelper.updateProfile(
        userModel: userModel,
      );
      OnBodingController.to.userModel.value =
          OnBodingController.to.userModel.value.copyWith(
              imageUrl: userModel.imageUrl,
              age: userModel.age,
              fullName: userModel.fullName,
              uid: userModel.uid);
      editAgeController.clear();
      editNameController.clear();
    } catch (exception, stack) {
      throw AppException.showException(exception, stack);
    }
  }
}
