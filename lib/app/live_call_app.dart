import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/core/routes/routes.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/profile/controller/profile_controller.dart';
import 'package:chat_app/modules/welcome/controller/welcome_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveCallApp extends StatelessWidget {
  const LiveCallApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Call App',
      theme: ThemeData(
        fontFamily: AssetsPath.robotoFlex,
      ),
      initialBinding: AppBidding(),
      initialRoute: Routes.onBodingScreen,
      getPages: Routes.routes,
    );
  }
}

class AppBidding implements Bindings {
  @override
  void dependencies() {
    Get.put(WelcomeController());
    Get.put(OnBodingController());
    Get.put(ProfileController());
    //Get.put(CallController());
  }
}
