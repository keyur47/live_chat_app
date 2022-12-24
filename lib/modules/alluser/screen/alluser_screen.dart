import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_string.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/routes/navigation.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/core/utills/size_utils.dart';
import 'package:chat_app/core/widgets/apptext_widget.dart';
import 'package:chat_app/core/widgets/icon_button.dart';
import 'package:chat_app/core/widgets/scaffold_widget.dart';
import 'package:chat_app/modules/bottombar/controller/dashboard_controller.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({Key? key}) : super(key: key);

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final DashboardController _dashboardController = Get.find();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScaffoldWidget(
      appBarTitle: AppStrings.userList,
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
          padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 1.5),
          child: SizedBox(
            width: double.infinity,
            child: StreamBuilder(
              stream: FirebaseHelper.collectionReference
                  .collection('UserData')
                  .where('uid',
                      isNotEqualTo: OnBodingController.to.userModel.value.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data!.docs.map(
                        (e) {
                          return Padding(
                            padding: EdgeInsets.all(
                                SizeUtils.horizontalBlockSize * 1.5),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: SizeUtils.horizontalBlockSize * 7,
                                backgroundImage: NetworkImage(
                                  e["imageUrl"] ??
                                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                                ),
                              ),
                              title: AppText(
                                title: e["fullName"],
                                fontSize: SizeUtils.fSize_16(),
                                fontWeight: FontWeight.w400,
                                color: AppColors.black,
                              ),
                              onTap: () async {
                                UserModel targetUser = UserModel.fromMap(
                                    e.data() as Map<String, dynamic>);
                                debugPrint("data name--${targetUser.fullName}");
                                await _dashboardController.getChatroomModel(
                                    targetUser,
                                    OnBodingController.to.userModel.value);
                                Navigation.pushNamed(Routes.chatScreen, arg: [
                                  {'targetUser': targetUser},
                                  {
                                    'currentUser':
                                        OnBodingController.to.userModel.value
                                  }
                                ]);
                              },
                            ),
                          );
                        },
                      ).toList(),
                    );
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
          )),
    ));
  }
}
