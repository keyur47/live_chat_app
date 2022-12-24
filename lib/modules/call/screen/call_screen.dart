import 'dart:math';

import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/modules/call/controller/call_controller.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../class/calling_class.dart';

class CallScreen extends StatefulWidget {
  CallScreen({Key? key}) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

final CallController _callController = Get.find();

class _CallScreenState extends State<CallScreen> {
  @override
  initState() {
    /// change in to podfile of ios
    /// jitsi_meet package
    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: _onConferenceWillJoin,
    //     onConferenceJoined: _onConferenceJoined,
    //     onConferenceTerminated: _onConferenceTerminated,
    //     onError: _onError));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    /// jitsi_meet package
    //JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: SizeUtils.screenHeight,
        width: SizeUtils.screenWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const [0.1, 0.6, 0.9],
            tileMode: TileMode.repeated,
            colors: <Color>[
              AppColors.gradientDarkBlue.withOpacity(0.90),
              AppColors.gradientMiddleBlue.withOpacity(0.75),
              AppColors.gradientLightBlue.withOpacity(0.70),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 8),
          child: Column(
            children: [
              SizedBox(
                height: SizeUtils.horizontalBlockSize * 20,
              ),
              Center(
                child: Image.asset(
                  AssetsPath.cafeImage,
                  scale: 4,
                ),
              ),
              SizedBox(
                height: SizeUtils.horizontalBlockSize * 55,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigation.pushNamed(Routes.profileScreen,
                        arg: Get.arguments);
                  },
                  child: Obx(
                    () => Container(
                      height: SizeUtils.verticalBlockSize * 5.5,
                      decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                              SizeUtils.verticalBlockSize * 4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OnBodingController.to.userModel.value.imageUrl
                                      ?.isNotEmpty ??
                                  false
                              ? Padding(
                                  padding: EdgeInsets.all(
                                      SizeUtils.verticalBlockSize * 0.3),
                                  child: Container(
                                    height: SizeUtils.verticalBlockSize * 11,
                                    width: SizeUtils.horizontalBlockSize * 11,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "${OnBodingController.to.userModel.value.imageUrl}"),
                                            fit: BoxFit.fill)),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(
                                      SizeUtils.verticalBlockSize * 0.3),
                                  child: Container(
                                    height: SizeUtils.verticalBlockSize * 11,
                                    width: SizeUtils.horizontalBlockSize * 11,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                            fit: BoxFit.fill)),
                                  ),
                                ),
                          SizedBox(
                            height: SizeUtils.verticalBlockSize * 11,
                            width: SizeUtils.horizontalBlockSize * 23,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AppText(
                                title: OnBodingController
                                        .to.userModel.value.fullName ??
                                    "",
                                maxLines: 1,
                                fontSize: SizeUtils.fSize_16(),
                                fontWeight: FontWeight.bold,
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.all(SizeUtils.verticalBlockSize * 1),
                            child: Icon(Icons.arrow_forward_ios_outlined,
                                color: AppColors.buttonColor,
                                size: SizeUtils.verticalBlockSize * 2.8),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: SizeUtils.horizontalBlockSize * 32,
                child: Stack(
                  children: [
                    Positioned(
                      left: SizeUtils.horizontalBlockSize * 3,
                      top: SizeUtils.horizontalBlockSize * 3,
                      child: Image.asset(
                        AssetsPath.largeHartIcon,
                        scale: 5,
                      ),
                    ),
                    Positioned(
                      right: SizeUtils.horizontalBlockSize * 25,
                      bottom: SizeUtils.horizontalBlockSize * 7,
                      child: Image.asset(
                        AssetsPath.smallHartIcon,
                        scale: 5,
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: CustomButton(
                        height: SizeUtils.horizontalBlockSize * 14,
                        text: AppStrings.tapToStart,
                        fontSize: SizeUtils.fSize_16(),
                        fontWeight: FontWeight.w500,
                        onTap: () async {
                          if (_callController.onlineUserList.isNotEmpty) {
                            // _callController.onlineUserList.shuffle();
                            int randomIndex = Random()
                                .nextInt(_callController.onlineUserList.length);
                            print(
                                "online user name===${_callController.onlineUserList[randomIndex].fullName}");
                            CallingClass().joinMeeting(
                              userName: _callController
                                      .onlineUserList[randomIndex].fullName ??
                                  "",
                              userUrl: _callController
                                  .onlineUserList[randomIndex].imageUrl
                                  .toString(),
                              roomText: _callController
                                  .onlineUserList[randomIndex].uid
                                  .toString(),
                              serverText: _callController.serverText,
                              isAudioCall: false,
                            );

                            /// video call entry

                            _callController.getCallingModel(
                                targetUser:
                                    _callController.onlineUserList[randomIndex],
                                currentUser:
                                    OnBodingController.to.userModel.value,
                                callType: AppStrings.videoCallType,
                                receiverStatus: AppStrings.missedCall,
                                senderStatus: AppStrings.calling);
                          }
                          Navigation.pushNamed(Routes.searchingScreen);
                        },
                        color: AppColors.white,
                        textColor: AppColors.buttonColor,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
