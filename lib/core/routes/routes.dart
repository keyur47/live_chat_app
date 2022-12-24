import 'package:chat_app/modules/alluser/screen/alluser_screen.dart';
import 'package:chat_app/modules/bottombar/screen/dashboard_screen.dart';
import 'package:chat_app/modules/chat/screen/chat_screen.dart';
import 'package:chat_app/modules/onboarding/screen/onboading_screen.dart';
import 'package:chat_app/modules/permission/screen/permission_screen.dart';
import 'package:chat_app/modules/profile/screen/profile_screen.dart';
import 'package:chat_app/modules/search/screen/searching_screen.dart';
import 'package:chat_app/modules/welcome/screen/welcome_screen.dart';
import 'package:get/get.dart';

mixin Routes {
  static const defaultTransition = Transition.rightToLeft;

  static const String onBodingScreen = '/onBodingScreen';
  static const String welcomeScreen = '/welcomeScreen';
  static const String permissionScreen = '/permissionScreen';
  static const String dashboardScreen = '/dashboardScreen';
  static const String searchingScreen = '/searchingScreen';
  static const String chatScreen = '/chatScreen';
  static const String allUserScreen = '/allUserScreen';
  static const String profileScreen = '/profileScreen';

  static List<GetPage<dynamic>> routes = [
    GetPage<dynamic>(
      name: onBodingScreen,
      page: () => OnBodingScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: welcomeScreen,
      page: () => WelcomeScreen(deviceId: Get.arguments),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: permissionScreen,
      page: () => PermissionScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: dashboardScreen,
      page: () => DashboardScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: searchingScreen,
      page: () => SearchingScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: chatScreen,
      page: () => ChatScreen(data: Get.arguments),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: allUserScreen,
      page: () => const AllUserScreen(),
      transition: defaultTransition,
    ),
    GetPage<dynamic>(
      name: profileScreen,
      page: () => ProfileScreen(),
      transition: defaultTransition,
    ),
  ];
}
