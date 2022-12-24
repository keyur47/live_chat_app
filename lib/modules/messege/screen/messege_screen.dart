import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:chat_app/modules/bottombar/controller/dashboard_controller.dart';
import 'package:chat_app/modules/chat/models/chate_model.dart';
import 'package:chat_app/modules/messege/controller/message_controller.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final MessageController _messageController = Get.find();
  final DashboardController _dashboardController = Get.find();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScaffoldWidget(
      appBarTitle: AppStrings.messages,
      leading: false,
      floatingButton: FloatingActionButton(
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Navigation.pushNamed(Routes.allUserScreen,
              arg: OnBodingController.to.userModel.value);
        },
        child: const Icon(
          Icons.message_rounded,
          color: AppColors.white,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: StreamBuilder(
          stream: FirebaseHelper.collectionReference
              .collection("ChatRoom")
              .where(
                  'participants.${OnBodingController.to.userModel.value.uid}',
                  isEqualTo: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot chatRoomSnapshot = snapshot.data as QuerySnapshot;

                return ListView.builder(
                    itemCount: chatRoomSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          chatRoomSnapshot.docs[index].data()
                              as Map<String, dynamic>);

                      UserModel? targetUserModel;
                      _messageController.allUserList.where((p0) {
                        String targetID = chatRoomModel.participants?.keys
                                .firstWhere((element) {
                              return element !=
                                  OnBodingController.to.userModel.value.uid;
                            }) ??
                            '';

                        if (targetID == p0.uid) {
                          targetUserModel = p0;
                          return true;
                        } else {
                          return false;
                        }
                      }).toList();
                      String time = DateFormat('hh:mm')
                          .format(chatRoomModel.lastMessageTime as DateTime);

                      return ListTile(
                        leading: CircleAvatar(
                          radius: SizeUtils.horizontalBlockSize * 6,
                          backgroundImage: NetworkImage(
                            targetUserModel?.imageUrl ??
                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                          ),
                        ),
                        title: AppText(
                          title: targetUserModel?.fullName.toString() ?? '',
                          fontSize: SizeUtils.fSize_16(),
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                        subtitle: AppText(
                          title: chatRoomModel.lastMessage ?? "",
                          fontSize: SizeUtils.fSize_12(),
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey,
                        ),
                        trailing: Column(
                          children: [
                            AppText(
                              title: _messageController.timeAgo(
                                  chatRoomModel.lastMessageTime as DateTime),
                              fontSize: SizeUtils.fSize_15(),
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withOpacity(0.60),
                            ),

                            /// code of how meny message without read
                            // CircleAvatar(
                            //   radius: SizeUtils.horizontalBlockSize * 3,
                            //   backgroundColor: AppColors.buttonColor,
                            //   child: AppText(
                            //     title: "2",
                            //     color: AppColors.white,
                            //     fontSize: SizeUtils.fSize_15(),
                            //     fontWeight: FontWeight.w700,
                            //   ),
                            // )
                          ],
                        ),
                        onTap: () async {
                          await _dashboardController.getChatroomModel(
                              targetUserModel!,
                              OnBodingController.to.userModel.value);
                          Navigation.pushNamed(Routes.chatScreen, arg: [
                            {'targetUser': targetUserModel},
                            {
                              'currentUser':
                                  OnBodingController.to.userModel.value
                            }
                          ]);
                        },
                      );
                    });
              } else if (snapshot.hasError) {
                return const Text("Snapshot has error");
              } else {
                return const CircularProgressIndicator();
              }
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    ));
  }
}
