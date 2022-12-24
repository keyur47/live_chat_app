import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:chat_app/modules/history/controller/history_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/service/firebase_service.dart';
import '../../chat/models/calling_model.dart';
import '../../messege/controller/message_controller.dart';
import '../../onboarding/controller/onboading_controller.dart';
import '../../welcome/model/user_model.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({Key? key}) : super(key: key);
  final HistoryController _historyController = Get.put(HistoryController());
  final MessageController _messageController = Get.find();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
          child: ScaffoldWidget(
        leading: false,
        appBarTitle: AppStrings.callHistory,
        child: createTabBar(),
      )),
    );
  }

  Widget createTabBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.horizontalBlockSize * 4,
          vertical: SizeUtils.verticalBlockSize * 2),
      child: Column(
        children: [
          Container(
            height: SizeUtils.verticalBlockSize * 6,
            decoration: BoxDecoration(
              color: AppColors.skyLight.withOpacity(0.20),
              borderRadius:
                  BorderRadius.circular(SizeUtils.horizontalBlockSize * 10),
            ),
            child: TabBar(
              padding: EdgeInsets.symmetric(
                  vertical: SizeUtils.horizontalBlockSize * 1.5, horizontal: 2),
              labelStyle: TextStyle(
                  fontSize: SizeUtils.fSize_15(), fontWeight: FontWeight.w500),
              controller: _historyController.tabController,
              indicator: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(SizeUtils.horizontalBlockSize * 10),
                color: AppColors.buttonColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(
                  text: AppStrings.all,
                ),
                Tab(
                  text: AppStrings.missed,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeUtils.horizontalBlockSize * 3,
          ),
          // tab bar view here
          Expanded(
            child: TabBarView(
              controller: _historyController.tabController,

              /// history user list
              children: [allWidget(), missedWidget()],
            ),
          ),
        ],
      ),
    );
  }

  Widget allWidget() {
    return StreamBuilder(
        stream: FirebaseHelper.collectionReference
            .collection("CallRoom")
            .where('participants.${OnBodingController.to.userModel.value.uid}',
                isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot callRoomSnapshot = snapshot.data as QuerySnapshot;
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  CallingModel callRoomModel = CallingModel.fromMap(
                      callRoomSnapshot.docs[index].data()
                          as Map<String, dynamic>);

                  UserModel? targetUserModel;
                  _messageController.allUserList.where((p0) {
                    String targetID =
                        callRoomModel.participants?.keys.firstWhere((element) {
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

                  /// today,yesterday
                  Map<String, dynamic> map = callRoomSnapshot.docs[index].data()
                      as Map<String, dynamic>;

                  return Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: (callRoomModel.senderStatus == 'Calling' &&
                                callRoomModel.senderId ==
                                    OnBodingController.to.userModel.value.uid)
                            ? Image.asset(
                                AssetsPath.blueIcon,
                                scale: 4,
                              )
                            : (callRoomModel.receiverStatus == 'Received')
                                ? Image.asset(
                                    AssetsPath.greenIcon,
                                    scale: 4,
                                  )
                                : Image.asset(
                                    AssetsPath.redIcon,
                                    scale: 4,
                                  ),
                      ),
                      Expanded(
                        flex: 9,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: SizeUtils.horizontalBlockSize * 7,
                            backgroundImage: NetworkImage(
                              targetUserModel?.imageUrl ??
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                            ),
                          ),
                          title: Text.rich(TextSpan(
                              text: "${targetUserModel?.fullName}-",
                              style: TextStyle(
                                  fontSize: SizeUtils.fSize_16(),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: _messageController.timeAgo(
                                      callRoomModel.createOn as DateTime),
                                  style: TextStyle(
                                      fontSize: SizeUtils.fSize_16(),
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey),
                                )
                              ])),
                          subtitle: AppText(
                            title: (callRoomModel.senderStatus ==
                                        AppStrings.calling &&
                                    callRoomModel.senderId ==
                                        OnBodingController
                                            .to.userModel.value.uid)
                                ? callRoomModel.senderStatus.toString()
                                : (callRoomModel.receiverStatus ==
                                        AppStrings.missedCall)
                                    ? callRoomModel.receiverStatus.toString()
                                    : (callRoomModel.callType ==
                                            AppStrings.videoCallType)
                                        ? "Random Match"
                                        : callRoomModel.receiverStatus
                                            .toString(),
                            fontSize: SizeUtils.fSize_12(),
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey,
                          ),
                          trailing: GestureDetector(
                            child: Image.asset(
                              AssetsPath.vedioCallIcon,
                              scale: 5,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: AppColors.grey,
                    thickness: 1,
                    height: 1,
                    indent: 7,
                    endIndent: 7,
                  );
                },
                itemCount: callRoomSnapshot.docs.length,
              );
            } else if (snapshot.hasError) {
              return const Text("Snapshot has error");
            } else {
              return const CircularProgressIndicator();
            }
          } else {
            return const SizedBox();
          }
        });
  }

  Widget missedWidget() {
    return StreamBuilder(
        stream: FirebaseHelper.collectionReference
            .collection("CallRoom")
            .where('participants.${OnBodingController.to.userModel.value.uid}',
                isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot callRoomSnapshot = snapshot.data as QuerySnapshot;
              return callRoomSnapshot.docs.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        CallingModel callRoomModel = CallingModel.fromMap(
                            callRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        UserModel? targetUserModel;
                        _messageController.allUserList.where((p0) {
                          String targetID = callRoomModel.participants?.keys
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

                        return (callRoomModel.senderId !=
                                    OnBodingController.to.userModel.value.uid &&
                                callRoomModel.receiverStatus ==
                                    AppStrings.missedCall)
                            ? Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.asset(
                                      AssetsPath.redIcon,
                                      scale: 4,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 9,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius:
                                            SizeUtils.horizontalBlockSize * 7,
                                        backgroundImage: NetworkImage(
                                          targetUserModel?.imageUrl ??
                                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                        ),
                                      ),
                                      title: Text.rich(TextSpan(
                                          text: "${targetUserModel?.fullName}-",
                                          style: TextStyle(
                                              fontSize: SizeUtils.fSize_16(),
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.black),
                                          children: <InlineSpan>[
                                            TextSpan(
                                              text: _messageController.timeAgo(
                                                  callRoomModel.createOn
                                                      as DateTime),
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeUtils.fSize_16(),
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColors.grey),
                                            )
                                          ])),
                                      subtitle: AppText(
                                        title: callRoomModel.receiverStatus
                                            .toString(),
                                        fontSize: SizeUtils.fSize_12(),
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.grey,
                                      ),
                                      trailing: GestureDetector(
                                        child: Image.asset(
                                          AssetsPath.vedioCallIcon,
                                          scale: 5,
                                        ),
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox();
                      },
                      separatorBuilder: (context, index) {
                        CallingModel callRoomModel = CallingModel.fromMap(
                            callRoomSnapshot.docs[index].data()
                                as Map<String, dynamic>);

                        return (callRoomModel.senderId !=
                                    OnBodingController.to.userModel.value.uid &&
                                callRoomModel.receiverStatus ==
                                    AppStrings.missedCall)
                            ? const Divider(
                                color: AppColors.grey,
                                thickness: 1,
                                height: 1,
                                indent: 7,
                                endIndent: 7,
                              )
                            : const SizedBox();
                      },
                      itemCount: callRoomSnapshot.docs.length,
                    )
                  : SizedBox();
            } else if (snapshot.hasError) {
              return const Text("Snapshot has error");
            } else {
              return const CircularProgressIndicator();
            }
          } else {
            return const SizedBox();
          }
        });
  }
}
