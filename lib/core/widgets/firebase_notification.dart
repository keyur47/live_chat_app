// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:freibr/core/app_constants.dart';
// import 'package:freibr/utils/join_meeting_class.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:rxdart/subjects.dart';
//
// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   log('receiveNotification _firebaseMessagingBackgroundHandler');
// // }
//
// class FireBaseNotification {
//   static RxInt isSelected = 0.obs;
//   static final FireBaseNotification _fireBaseNotification =
//       FireBaseNotification.init();
//
//   factory FireBaseNotification() {
//     return _fireBaseNotification;
//   }
//
//   FireBaseNotification.init();
//
//   // final DashBoardController dashBoardController = Get.find();
//   late FirebaseMessaging firebaseMessaging;
//   late AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     // 'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );
//
//   final _selectNotificationSubject = PublishSubject<String?>();
//
//   Stream<String?> get selectNotificationStream =>
//       _selectNotificationSubject.stream;
//
//   final _didReceiveLocalNotificationSubject =
//       PublishSubject<ReceivedNotification>();
//
//   Stream<ReceivedNotification> get didReceiveLocalNotificationStream =>
//       _didReceiveLocalNotificationSubject.stream;
//
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static bool isNotification = false;
//
//   void firebaseCloudMessagingLSetup() async {
//     firebaseMessaging = FirebaseMessaging.instance;
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//
//     iOSPermission(firebaseMessaging);
//
//     await firebaseMessaging.getToken().then((token) {
//       // Constants.firebaseToken = token!;
//       log('log fcm Firebase Messaging TOKEN: $token');
//       Platform.isIOS
//           ? debugPrint('fcm Firebase Messaging TOKEN: $token')
//           : null;
//     });
//
//     // Fired when app is coming from a terminated state
//     // var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     // if (initialMessage != null) _showLocalNotification(initialMessage);
//
//     // Fired when app is in foreground
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log('receiveNotification onMessage');
//       var data = message.data['joinVoiceCallFromNotification'];
//       if (data == 'true') {
//         log('receiveNotification onMessage 00');
//         // await SharePrefs.saveVoiceCallMessage(true);
//         // buttonClickedTimes.value = 1;
//       }
//       _showLocalNotification(message);
//       // debugPrint('Got a message, app is in the foreground!');
//     });
//
//     // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//     // Fired when app is in foreground
//     FirebaseMessaging.onMessageOpenedApp.listen((
//       RemoteMessage message,
//     ) {
//       log('receiveNotification onMessageOpenedApp');
//       log("message.data: ${message.data}");
//       selectNotification(message.data);
//       // debugPrint('Got a message, app is in the foreground!');
//     });
//   }
//
//   Future<void> setUpLocalNotification() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@drawable/ic_notification');
//
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false,
//             defaultPresentBadge: true,
//             defaultPresentAlert: true,
//             defaultPresentSound: true,
//             onDidReceiveLocalNotification: (
//               int id,
//               String? title,
//               String? body,
//               String? payload,
//             ) async {
//               _didReceiveLocalNotificationSubject.add(
//                 ReceivedNotification(
//                   id: id,
//                   title: title,
//                   body: body,
//                   payload: payload,
//                 ),
//               );
//             });
//
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) {
//       // selectNotification(payload);
//     });
//     // print("flutterLocalNotificationsPlugin Complete");
//   }
//
//   Future selectNotification(Map<String, dynamic> payload) async {
//     print(
//         "selectNotification: payload: $payload screen: ${payload['screen']} roomId: ${payload['roomId']} isOpen: ${payload == 'meeting'}");
//     if (payload['screen'] != null && payload.isNotEmpty) {
//       if (payload['screen'] == 'meeting') {
//         // JoinMeetingClass().joinMeeting(roomId: '');
//
//         Get.to(() => LiveChatSessionScreen());
//         JoinMeetingClass().joinMeeting(
//           roomId: payload['roomId'],
//         );
//       } else if (payload['screen'] == 'voiceCall') {
//         JitsiVoiceCallingClass()
//             .joinVoiceCallMeeting(userId: payload['roomId']);
//         print(
//             'JitsiVoiceCallingClass joinMeetingfromNotification ==> ${payload['roomId']}');
//         var pushToken = payload['pushToken'];
//         if (pushToken != null && pushToken != '') {
//           print('pushToken ===> $pushToken');
//           sendFirebaseNotification(pushToken);
//         }
//       }
//
//       // else if (payload == 'CommentScreen') {
//       //   Get.toNamed(DashBoardScreen.routeName);
//       //   isSelected.value = 1;
//       // } else if (payload == 'HomeScreen') {
//       //   Get.toNamed(DashBoardScreen.routeName);
//       //   isSelected.value = 0;
//       // } else if (payload == 'updateScreen') {
//       //   Get.toNamed(DashBoardScreen.routeName);
//       //   isSelected.value = 3;
//       // }
//       // _selectNotificationSubject.add(payload);
//     }
//   }
//
//   selectPushNotification() {
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null) {
//         // firebaseUtils?.isSelectPage =
//         //     firebaseUtils?.selectPage(message) ?? false;
//         selectNotification(message.data);
//       }
//     });
//   }
//
//   void iOSPermission(firebaseMessaging) {
//     firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }
//
//   void _showLocalNotification(RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'high_importance_channel', 'High Importance Notifications',
//       colorized: true,
//       playSound: true,
//       channelDescription: 'Notification channel',
//       importance: Importance.high,
//       // icon: '@drawable/ic_notification.png',
//       // largeIcon:
//       //     DrawableResourceAndroidBitmap('@drawable/ic_notification'),
//       priority: Priority.high,
//     );
//
//     const IOSNotificationDetails iOSPlatformChannelSpecifics =
//         IOSNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//
//     await flutterLocalNotificationsPlugin.show(
//         0, notification!.title, notification.body, platformChannelSpecifics,
//         payload: '');
//
//     // AndroidNotification? android = message.notification?.android;
//     // flutterLocalNotificationsPlugin.show(
//     //   notification.hashCode,
//     //   notification!.title,
//     //   notification.body,
//     //   NotificationDetails(
//     //     android: AndroidNotificationDetails(
//     //       channel.id,
//     //       channel.name,
//     //       // channel.description,
//     //       // TODO add a proper drawable resource to android, for now using
//     //       //      one that already exists in example app.
//     //       icon: 'launch_background',
//     //     ),
//     //   ),
//     // );
//   }
//
//   //
//   void localNotificationRequestPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }
//
//   void configureDidReceiveLocalNotificationSubject() {
//     // print('configureDidReceiveLocalNotificationSubject stream listen');
//     didReceiveLocalNotificationStream
//         .listen((ReceivedNotification receivedNotification) async {
//       print(
//           "configureDidReceiveLocalNotificationSubject 00: $receivedNotification");
//     });
//   }
//
//   void configureSelectNotificationSubject() {
//     // print("configureSelectNotificationSubject stream listen");
//     selectNotificationStream.listen((String? payload) {
//       print("configureSelectNotificationSubject 00: $payload");
//     });
//   }
//
//   void localNotificationDispose() {
//     _didReceiveLocalNotificationSubject.close();
//     _selectNotificationSubject.close();
//   }
//
//   void subscribeTopic() {
//     firebaseMessaging.subscribeToTopic('JoinTheLive');
//     firebaseMessaging.subscribeToTopic('JoinTheVoiceCall');
//   }
//
//   void unSubscribeTopic() {
//     firebaseMessaging.unsubscribeFromTopic('JoinTheLive');
//     firebaseMessaging.unsubscribeFromTopic('JoinTheVoiceCall');
//   }
//
//   void sendFirebaseNotification(String pushToken) async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     final response = await http.post(
//       Uri.parse('https://fcm.googleapis.com/fcm/send'),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization':
//             // 'key=AAAAa4brFQM:APA91bERg8L83SOeHvvuUelUMQgRyMNpEOlfAUdGfoKLIhkzOeLQTGDjdalhPhrOgP_me7SllyjyeT8LaUI3soIMAFmER-lkXJXfU6nFtBYwuJlbAIXOSy7cUWasnknN8gnWZOiKXCHB',
//             'key=AAAAngOBy6Q:APA91bGd1qI26tyS2Y86h2ynhLPproxi0RT9ZfaAjNegsV1NW_1Cq6fe3H9clJt9s5hcyd80nDldl1atlcP1HrmSlv7NMG5eVGs25aTmnWzWF9rsDjBp2DFgqMeWyX9yl6GpMUBfQaFA',
//       },
//       body: jsonEncode(
//         <String, dynamic>{
//           'notification': <String, dynamic>{
//             'body': 'voiceCallNotification',
//             'title': '123'
//           },
//           'priority': 'high',
//           'data': <String, dynamic>{
//             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//             'joinVoiceCallFromNotification': 'true',
//           },
//           'to': '$pushToken',
//         },
//       ),
//     );
//
//     print('response.statusCode ----->>>>${response.runtimeType}');
//     if (response.statusCode == 200) {
//       print("Success");
//     } else {
//       print("failed");
//     }
//   }
// }
//
// class ReceivedNotification {
//   ReceivedNotification({
//     required this.id,
//     required this.title,
//     required this.body,
//     required this.payload,
//   });
//
//   final int id;
//   final String? title;
//   final String? body;
//   final String? payload;
// }
//
// // Future<void> _showMyDialog(roomId, avatarUrl,userName) async {
// //   return showDialog<void>(
// //     context: Get.context!,
// //     barrierDismissible: false, // user must tap button!
// //     builder: (BuildContext context) {
// //       return AlertDialog(
// //         title: const Text('AlertDialog Title'),
// //         content: SingleChildScrollView(
// //           child: ListTile(
// //             title: Text('$userName is calling'),
// //             leading: CircleAvatar(
// //               backgroundImage: NetworkImage(avatarUrl),
// //             ),
// //           ),
// //         ),
// //         actions: <Widget>[
// //           TextButton(
// //             child: const Text('Approve'),
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //               JitsiVoiceCallingClass().joinVoiceCallMeeting(userId: roomId);
// //             },
// //           ),
// //         ],
// //       );
// //     },
// //   );
// // }
