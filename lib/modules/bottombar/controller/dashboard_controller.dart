import 'dart:developer';

import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/chat/models/chate_model.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:chat_app/modules/welcome/screen/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/firebase_notification_second.dart';

class DashboardController extends GetxController with WidgetsBindingObserver {
  RxInt selectedIndex = 0.obs;
  OnBodingController onBodingController = Get.find();
  RxString deviceToken = "".obs;

  @override
  onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    await FireBaseNotification().firebaseCloudMessagingLSetup(
        OnBodingController.to.userModel.value.uid.toString());

    /// send notificatin
    // FireBaseNotification().localNotificationRequestPermissions();
    // FireBaseNotification().configureDidReceiveLocalNotificationSubject();
    // FireBaseNotification().configureSelectNotificationSubject();
    log('----------------');
  }

  @override
  onClose() {
    WidgetsBinding.instance.removeObserver(this);
    setStatus("Offline");
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    try {
      if (state == AppLifecycleState.resumed) {
        setStatus("Online");
      } else {
        setStatus("Offline");
      }
      log('state ================= $state');
    } catch (e) {
      log('error in didChangeApplifecycle----$e');
    }
  }

  void setStatus(String status) async {
    try {
      await FirebaseHelper.collectionReference
          .collection('UserData')
          .doc(OnBodingController.to.userModel.value.uid)
          .update({
        "status": status,
      }).then((value) => log("user updated"));
    } catch (e) {
      log("error in setStatus----$e");
    }
  }

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }

  ChatRoomModel? chatRoom;
  RxString chatroomId = "".obs;
  Future<ChatRoomModel?> getChatroomModel(
      UserModel targetUser, UserModel currentUser) async {
    log("current user name==${currentUser.fullName}");
    log("target user name==${targetUser.fullName}");

    QuerySnapshot snapshot = await FirebaseHelper.collectionReference
        .collection("ChatRoom")
        .where("participants.${currentUser.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      log("existing chat room open");

      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      log("new chat room created");
      chatroomId.value = uuid.v1();
      ChatRoomModel newChatroom = ChatRoomModel(
          chatroomid: chatroomId.value.toString(),
          lastMessage: "",
          lastMessageTime: DateTime.now(),
          participants: {
            currentUser.uid.toString(): true,
            targetUser.uid.toString(): true,
          });
      await FirebaseHelper.collectionReference
          .collection("ChatRoom")
          .doc(newChatroom.chatroomid)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }
    // update();
    refresh();
    return chatRoom;
  }
}
