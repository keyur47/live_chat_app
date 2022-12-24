import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_string.dart';
import '../../chat/models/calling_model.dart';
import '../../onboarding/controller/onboading_controller.dart';
import '../../welcome/screen/welcome_screen.dart';

class CallController extends GetxController {
  RxList<UserModel> onlineUserList = <UserModel>[].obs;
  final serverText = TextEditingController();
  CallingModel? callRoom;
  RxString callRoomId = "".obs;
  RxBool isCallReceived = false.obs;

  void getAllOnlineUserStreamListen() {
    FirebaseHelper.collectionReference
        .collection("UserData")
        .where('uid', isNotEqualTo: OnBodingController.to.userModel.value.uid)
        .where('status', isEqualTo: 'Online')
        .snapshots()
        .listen((event) {
      onlineUserList.clear();
      for (var element in event.docs) {
        onlineUserList.add(UserModel.fromMap(element.data()));
      }
    });
    print("online user list lentg=${onlineUserList.length}");
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<CallingModel?> getCallingModel(
      {required UserModel targetUser,
      required UserModel currentUser,
      required String senderStatus,
      required String receiverStatus,
      required String callType}) async {
    callRoomId.value = uuid.v1();
    CallingModel newCallRoom = CallingModel(
        callingId: callRoomId.value.toString(),
        senderStatus: senderStatus,
        receiverStatus: receiverStatus,
        callType: callType,
        senderId: currentUser.uid.toString(),
        createOn: DateTime.now(),
        participants: {
          currentUser.uid.toString(): true,
          targetUser.uid.toString(): true,
        });
    await FirebaseHelper.collectionReference
        .collection("CallRoom")
        .doc(newCallRoom.callingId)
        .set(newCallRoom.toMap());

    callRoom = newCallRoom;
    print("callroom id is======${callRoom?.callingId}");
    //refresh();
    return callRoom;
  }

  void onReceivedCall() {
    print("call room id is===${callRoom?.callingId}");
    FirebaseHelper.collectionReference
        .collection("CallRoom")
        .doc(callRoom?.callingId)
        .update({'receiverStatus': AppStrings.received}).then((value) {
      print("update success");
    });
    // if (isCallReceived.value) {
    //   isCallReceived.value = false;
    //   print(
    //       "is call recevied after value issssss---------${isCallReceived.value}");
    // }
  }
}
