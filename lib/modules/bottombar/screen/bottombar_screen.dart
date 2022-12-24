// import 'package:flutter/material.dart';
// import 'package:live_call_app/core/constants/app_colors.dart';
// import 'package:live_call_app/core/constants/asset_path.dart';
// import 'package:live_call_app/core/utills/size_utils.dart';
// import 'package:live_call_app/modules/call/screen/call_screen.dart';
// import 'package:live_call_app/modules/favorite/screen/favorite_screen.dart';
// import 'package:live_call_app/modules/history/screen/history_screen.dart';
// import 'package:live_call_app/modules/messege/screen/massege_screen.dart';
// import 'package:live_call_app/modules/online/screen/online_screen.dart';
// import 'package:live_call_app/modules/welcome/model/user_model.dart';
//
// class BottomBarScreen extends StatefulWidget {
//   const BottomBarScreen({Key? key, this.userModel}) : super(key: key);
//   final UserModel? userModel;
//
//   @override
//   State<BottomBarScreen> createState() => _BottomBarScreenState();
// }
//
// class _BottomBarScreenState extends State<BottomBarScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _widgetOptions = <Widget>[
//     const CallScreen(),
//     const OnlineScreen(),
//     const FavoriteScreen(),
//     const MessageScreen(),
//     HistoryScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: _widgetOptions.elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.all(SizeUtils.horizontalBlockSize * 1),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           elevation: 2.0,
//           backgroundColor: AppColors.white,
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Image.asset(
//                 AssetsPath.call2Icon,
//                 scale: 4,
//                 color: _selectedIndex == 0 ? AppColors.buttonColor : null,
//               ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: _selectedIndex == 1
//                   ? Image.asset(
//                       AssetsPath.onlineBlueIcon,
//                       scale: 4,
//                     )
//                   : Image.asset(
//                       AssetsPath.internetIcon,
//                       scale: 4,
//                     ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: _selectedIndex == 2
//                   ? Image.asset(
//                       AssetsPath.favoriteBlueIcon,
//                       scale: 4,
//                     )
//                   : Image.asset(
//                       AssetsPath.favoriteIcon,
//                       scale: 4,
//                     ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: _selectedIndex == 3
//                   ? Image.asset(
//                       AssetsPath.chatBlueIcon,
//                       scale: 4,
//                     )
//                   : Image.asset(
//                       AssetsPath.chatIcon,
//                       scale: 4,
//                     ),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: _selectedIndex == 4
//                   ? Image.asset(
//                       AssetsPath.historyBlueIcon,
//                       scale: 4,
//                     )
//                   : Image.asset(
//                       AssetsPath.historyIcon,
//                       scale: 4,
//                     ),
//               label: '',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: AppColors.buttonColor,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
// }
