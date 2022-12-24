import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/custom_textfield.dart';
import 'package:chat_app/core/widgets/icon_button.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:chat_app/modules/bottombar/controller/dashboard_controller.dart';
import 'package:chat_app/modules/chat/controller/chat_controller.dart';
import 'package:chat_app/modules/messege/model/message_model.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../call/class/calling_class.dart';
import '../../call/controller/call_controller.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key, this.data}) : super(key: key);
  var data;
  final ChatController _chatController = Get.put(ChatController());
  final DashboardController _dashboardController = Get.find();
  final CallController _callController = Get.find();

  @override
  Widget build(BuildContext context) {
    final UserModel myTargetUser = data[0]['targetUser'];

    final UserModel myCurrentUser = data[1]['currentUser'];
    debugPrint("target user----${myTargetUser.fullName}");
    debugPrint("current user----${myCurrentUser.fullName}");

    return SafeArea(
      child: ScaffoldWidget(
        appBarTitleWidget: ListTile(
          leading: CircleAvatar(
            radius: SizeUtils.horizontalBlockSize * 6,
            backgroundImage: NetworkImage(
              myTargetUser.imageUrl ??
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
            ),
          ),
          title: AppText(
            title: myTargetUser.fullName ?? "",
            fontSize: SizeUtils.fSize_16(),
            fontWeight: FontWeight.w400,
            color: AppColors.white,
          ),
          subtitle: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseHelper.collectionReference
                .collection("UserData")
                .doc(myTargetUser.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  dynamic data = snapshot.data;
                  return AppText(
                    title: data["status"].toString(),
                    fontSize: SizeUtils.fSize_12(),
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  );
                } else {
                  return AppText(
                    title: "",
                    fontSize: SizeUtils.fSize_12(),
                    fontWeight: FontWeight.w400,
                    color: AppColors.white,
                  );
                }
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
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

        /// call ico
        actions: [
          Padding(
              padding: EdgeInsets.all(SizeUtils.verticalBlockSize * 1),
              child: IconButtonWidget(
                buttonColor: AppColors.skyLight.withOpacity(0.20),
                child: Image.asset(
                  AssetsPath.callIcon,
                  scale: 4,
                ),
                onTap: () async {
                  _chatController.isAudio.value = true;
                  _callController.isCallReceived.value = false;
                  _chatController.messageController.text = "Audio Calling";

                  _chatController.sendMessage(
                      myCurrentUser, _dashboardController.chatRoom!);
                  CallingClass().joinMeeting(
                      userName: myTargetUser.fullName ?? "",
                      userUrl: myTargetUser.imageUrl.toString(),
                      roomText: myCurrentUser.uid.toString(),
                      serverText: TextEditingController(),
                      isAudioCall: true,
                      isReceiver: false);

                  await _callController.getCallingModel(
                      targetUser: myTargetUser,
                      currentUser: myCurrentUser,
                      senderStatus: AppStrings.calling,
                      receiverStatus: AppStrings.missedCall,
                      callType: AppStrings.audioCallType);

                  /// send notificatin
                  // await FireBaseNotification().sendFirebaseNotification(
                  //     pushToken: myCurrentUser.deviceToken.toString(),
                  //     title: myCurrentUser.fullName.toString(),
                  //     targetUserId: myTargetUser.uid.toString(),
                  //     screenName: 'audio');
                },
              )),
        ],
        child: Column(
          children: [
            SizedBox(
              height: SizeUtils.horizontalBlockSize * 4.5,
            ),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: StreamBuilder(
                  stream: FirebaseHelper.collectionReference
                      .collection("ChatRoom")
                      .doc(_dashboardController.chatRoom?.chatroomid)
                      .collection("messages")
                      .orderBy("createOn", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: dataSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel currentMessage = MessageModel.fromJson(
                              dataSnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          /// show time with AM/PM
                          String time = _chatController.timewithAmPm(
                              currentMessage.createOn as DateTime);

                          /// today,yesterday
                          Map<String, dynamic> map = dataSnapshot.docs[index]
                              .data() as Map<String, dynamic>;

                          bool dateVisibility = _chatController.shouldShowDate(
                                  map['createOn'],
                                  (index < (dataSnapshot.docs.length) - 1)
                                      ? (dataSnapshot.docs[index + 1].data()
                                          as Map<String, dynamic>)['createOn']
                                      : map['createOn'],
                                  dataSnapshot.docs) ||
                              index == (dataSnapshot.docs.length) - 1;

                          return Column(
                            children: [
                              dateVisibility
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          color: AppColors.skyLight),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeUtils.horizontalBlockSize *
                                                    3.5,
                                            vertical:
                                                SizeUtils.verticalBlockSize *
                                                    1.5),
                                        child: Text(_chatController.timeAgo(
                                            currentMessage.createOn
                                                as DateTime)),
                                      ),
                                    )
                                  : const SizedBox(),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeUtils.horizontalBlockSize * 2),
                                alignment:
                                    currentMessage.sender == myCurrentUser.uid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                child: InkWell(
                                  child: Padding(
                                    padding: (currentMessage.sender ==
                                            myCurrentUser.uid)
                                        ? EdgeInsets.only(
                                            left:
                                                SizeUtils.horizontalBlockSize *
                                                    6)
                                        : EdgeInsets.only(
                                            right:
                                                SizeUtils.horizontalBlockSize *
                                                    6),
                                    child: Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical:
                                              SizeUtils.horizontalBlockSize *
                                                  0.5,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeUtils.horizontalBlockSize * 2,
                                          horizontal:
                                              SizeUtils.horizontalBlockSize * 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (currentMessage.sender ==
                                                  myTargetUser.uid)
                                              ? AppColors.skyLight
                                              : AppColors.buttonColor
                                                  .withOpacity(0.70),
                                          borderRadius: (currentMessage
                                                      .sender ==
                                                  myTargetUser.uid)
                                              ? const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  topRight: Radius.circular(10))
                                              : const BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10),
                                                  topLeft: Radius.circular(10)),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AppText(
                                              title: currentMessage.text
                                                  .toString(),
                                              color: (currentMessage.sender ==
                                                      myTargetUser.uid)
                                                  ? AppColors.white
                                                  : AppColors.black,
                                              fontSize: SizeUtils.fSize_14(),
                                              fontWeight: FontWeight.w400,
                                              softWrap: true,
                                              maxLines: 20,
                                            ),
                                            AppText(
                                              title: time.toString(),
                                              color: (currentMessage.sender ==
                                                      myTargetUser.uid)
                                                  ? AppColors.white
                                                  : AppColors.black,
                                              fontSize: SizeUtils.fSize_14(),
                                              fontWeight: FontWeight.w400,
                                            )
                                          ],
                                        )),
                                  ),

                                  /// code for delete message
                                  onLongPress: () {
                                    Get.defaultDialog(
                                      title: 'Delete',
                                      middleText: 'Delete this message',
                                      onCancel: () {},
                                      cancelTextColor: AppColors.teamColor,
                                      confirmTextColor: AppColors.teamColor,
                                      onConfirm: () {
                                        _chatController.deleteMessage(
                                            _dashboardController
                                                    .chatRoom?.chatroomid ??
                                                "",
                                            currentMessage.messageId
                                                .toString());
                                      },
                                    );
                                  },

                                  /// receive audio call
                                  onTap: () async {
                                    if (currentMessage.sender !=
                                            myCurrentUser.uid &&
                                        _chatController.isAudio.value) {
                                      _callController.isCallReceived.value =
                                          true;
                                      try {
                                        await CallingClass().joinMeeting(
                                            userName:
                                                myTargetUser.fullName ?? "",
                                            userUrl: myTargetUser.imageUrl
                                                .toString(),
                                            roomText:
                                                myTargetUser.uid.toString(),
                                            serverText: TextEditingController(),
                                            isAudioCall: true,
                                            isReceiver: true);
                                        _chatController.isAudio.value = false;
                                        _chatController.audioMsgId.value =
                                            currentMessage.messageId.toString();
                                      } catch (e) {
                                        print(
                                            "error in received call-------$e");
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("An error occurred! Please check your "
                            "internet connection."),
                      );
                    } else {
                      return const Center(
                        child: Text("Say hi to your new friend"),
                      );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: SizeUtils.horizontalBlockSize * 1,
                  left: SizeUtils.horizontalBlockSize * 3,
                  right: SizeUtils.horizontalBlockSize * 3,
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      SizeUtils.horizontalBlockSize * 2),
              child: Row(
                children: [
                  SizedBox(
                    height: SizeUtils.horizontalBlockSize * 15,
                    width: SizeUtils.horizontalBlockSize * 79,
                    child: CustomTextField(
                      controller: _chatController.messageController,
                      hintText: AppStrings.message,
                      //maxLine: null,
                    ),
                  ),
                  SizedBox(
                    width: SizeUtils.horizontalBlockSize * 2,
                  ),
                  IconButtonWidget(
                    height: SizeUtils.horizontalBlockSize * 13,
                    width: SizeUtils.horizontalBlockSize * 13,
                    onTap: () async {
                      _chatController.isAudio.value = false;
                      _chatController.sendMessage(
                          myCurrentUser, _dashboardController.chatRoom!);
                    },
                    buttonColor: AppColors.buttonColor,
                    child: Icon(
                      Icons.send,
                      size: SizeUtils.verticalBlockSize * 2.8,
                      color: AppColors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
