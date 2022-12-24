import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/asset_path.dart';
import 'package:chat_app/modules/bottombar/controller/dashboard_controller.dart';
import 'package:chat_app/modules/call/controller/call_controller.dart';
import 'package:chat_app/modules/call/screen/call_screen.dart';
import 'package:chat_app/modules/history/screen/history_screen.dart';
import 'package:chat_app/modules/messege/controller/message_controller.dart';
import 'package:chat_app/modules/online/screen/online_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../favorite/screen/favorite_screen.dart';
import '../../messege/screen/messege_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  final DashboardController _dashboardController =
      Get.put(DashboardController());
  final MessageController _messageController = Get.put(MessageController())
    ..getAllUserDataStreamListen();
  final CallController _callController = Get.put(CallController())
    ..getAllOnlineUserStreamListen();
  final List<Widget> _widgetOptions = <Widget>[
    CallScreen(),
    OnlineScreen(),
    const FavoriteScreen(),
    const MessageScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: _widgetOptions
              .elementAt(_dashboardController.selectedIndex.value),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedFontSize: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 2.0,
          iconSize: 20.0,
          backgroundColor: AppColors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                AssetsPath.call2Icon,
                scale: 4,
                color: _dashboardController.selectedIndex.value == 0
                    ? AppColors.buttonColor
                    : null,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _dashboardController.selectedIndex.value == 1
                  ? Image.asset(
                      AssetsPath.onlineBlueIcon,
                      scale: 4,
                    )
                  : Image.asset(
                      AssetsPath.internetIcon,
                      scale: 4,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _dashboardController.selectedIndex.value == 2
                  ? Image.asset(
                      AssetsPath.favoriteBlueIcon,
                      scale: 4,
                    )
                  : Image.asset(
                      AssetsPath.favoriteIcon,
                      scale: 4,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _dashboardController.selectedIndex.value == 3
                  ? Image.asset(
                      AssetsPath.chatBlueIcon,
                      scale: 4,
                    )
                  : Image.asset(
                      AssetsPath.chatIcon,
                      scale: 4,
                    ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: _dashboardController.selectedIndex.value == 4
                  ? Image.asset(
                      AssetsPath.historyBlueIcon,
                      scale: 4,
                    )
                  : Image.asset(
                      AssetsPath.historyIcon,
                      scale: 4,
                    ),
              label: '',
            ),
          ],
          currentIndex: _dashboardController.selectedIndex.value,
          selectedItemColor: AppColors.buttonColor,
          onTap: _dashboardController.changeTabIndex,
        ),
      ),
    );
  }
}
