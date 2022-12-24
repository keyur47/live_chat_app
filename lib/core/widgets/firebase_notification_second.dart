import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/core/service/firebase_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';

ValueNotifier<String> notificationBody = ValueNotifier<String>('');

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('receiveNotification _firebaseMessagingBackgroundHandler data: ${message.data}');
  await Firebase.initializeApp();
}

class FireBaseNotification {
  // final AuthServices _authService = AuthServices();
  static final FireBaseNotification _fireBaseNotification =
      FireBaseNotification.init();

  factory FireBaseNotification() => _fireBaseNotification;

  FireBaseNotification.init();

  late FirebaseMessaging firebaseMessaging;
  late AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// A notification action which triggers a App navigation event
  String navigationActionId = 'id_3';

  final _selectNotificationSubject = PublishSubject<String?>();

  Stream<String?> get selectNotificationStream =>
      _selectNotificationSubject.stream;

  final _didReceiveLocalNotificationSubject =
      PublishSubject<ReceivedNotification>();

  Stream<ReceivedNotification> get didReceiveLocalNotificationStream =>
      _didReceiveLocalNotificationSubject.stream;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static bool isNotification = false;

  Future firebaseCloudMessagingLSetup(String currentUserId) async {
    firebaseMessaging = FirebaseMessaging.instance;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // iOSPermission(firebaseMessaging);

    await firebaseMessaging.getToken().then((token) {
      /// required to save in utils
      log('FCM TOKEN to be Registered: $token');

      ///coment me
      FirebaseHelper.collectionReference
          .collection("UserData")
          .doc(currentUserId)
          .update({'deviceToken': token});
    }).catchError((err) {
      print("error in firebase gettoken===$err");
      throw err;
    });

    // Fired when app is coming from a terminated state
    // var initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // if (initialMessage != null) _showLocalNotification(initialMessage);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      // print('data======:${initialMessage.data}');
      /// payload data
      // NavigationUtils.notificationNavigationName = initialMessage.data['screenName'].toString();
      // NavigationUtils.notificationNavigationRoomId = initialMessage.data['roomId'].toString();
      // NavigationUtils.notificationNavigationWithChatUserId = initialMessage.data['withChatUserId'].toString();
    }
    // Fired when app is in foreground and get notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // log('receiveNotification onAppOpen onMessage data: ${message.notification?.toMap()}');
      // log('receiveNotification onAppOpen onMessage data 00: ${message.data}');
      showLocalNotification(message);
      notificationBody.value = message.notification?.title?.toString() ?? '';
    });

    // Fired when app is in foreground and click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      selectNotification(json.encode(message.data));
      // log('Got a message, app is in the foreground! ${message.data.toString()}');
    });
  }

  Future<void> initializeNotification() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
              onDidReceiveLocalNotification: (
                int id,
                String? title,
                String? body,
                String? payload,
              ) async {
                _didReceiveLocalNotificationSubject.add(
                  ReceivedNotification(
                    id: id,
                    title: title,
                    body: body,
                    payload: payload,
                  ),
                );
              });

      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS);

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    } catch (e, st) {
      print("error in initiallize notification$e............$st ");
    }

    // log("flutterLocalNotificationsPlugin Complete");
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    log("onDidReceiveNotificationResponse notification");

    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        _selectNotificationSubject.add(notificationResponse.payload);
        // log('receiveNotification configureSelectNotificationSubject selectedNotification');
        Map<String, dynamic> data = notificationResponse.payload != null
            ? json.decode(notificationResponse.payload ?? '')
            : {};

        log("payload data is====${data['targetUserId']}");

        // Navigation.pushNamed(Routes.chatScreen, arg: [
        //   {'targetUser': targetUserModel},
        //   {
        //     'currentUser':
        //     OnBodingController.to.userModel.value
        //   }
        // ]);
        break;
      case NotificationResponseType.selectedNotificationAction:
        if (notificationResponse.actionId == navigationActionId) {
          _selectNotificationSubject.add(notificationResponse.payload);
          // log('receiveNotification configureSelectNotificationSubject selectedNotificationAction');

          Map<String, dynamic> data = notificationResponse.payload != null
              ? json.decode(notificationResponse.payload ?? '')
              : {};

          ///coment me
          // NavigationUtils.navigationSwitch(data);
        }
        break;
    }
  }

  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    log("onDidReceiveBackgroundNotificationResponse notification");
    // log('notification(${notificationResponse.id}) action tapped: '
    //     '${notificationResponse.actionId} with'
    //     ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      log('notification action tapped with input: ${notificationResponse.input}');
    }
  }

  Future selectNotification(String? notificationPayload) async {
    if (notificationPayload != null && notificationPayload.isNotEmpty) {
      log('receiveNotification getInitialMessage 00');
      _selectNotificationSubject.add(notificationPayload);
    }
  }

  void showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            //largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_largeIcon'),
            icon: '@mipmap/ic_launcher',
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, notification!.title, notification.body, platformChannelSpecifics,
        payload: json.encode(message.data));
  }

  void localNotificationRequestPermissions() {
    try {
      log("--------localNotificationRequestPermissions-------");
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } catch (e) {
      log("error in localNotificationRequestPermissions+++++++++$e");
    }
  }

  void iOSPermission(firebaseMessaging) {
    firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> sendFirebaseNotification({
    required String pushToken,
    required String title,
    required String targetUserId,
    required String screenName,
  }) async {
    try {
      print("target user id token=====$pushToken");
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAngOBy6Q:APA91bGd1qI26tyS2Y86h2ynhLPproxi0RT9ZfaAjNegsV1NW_1Cq6fe3H9clJt9s5hcyd80nDldl1atlcP1HrmSlv7NMG5eVGs25aTmnWzWF9rsDjBp2DFgqMeWyX9yl6GpMUBfQaFA',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': "body",
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'joinChatWithNotification': 'true',
              'targetUserId': targetUserId,
              'screenName': screenName
            },
            'to': pushToken,
          },
        ),
      );

      log('response.statusCode ----->>>>${response.statusCode}');
      if (response.statusCode == 200) {
        log("Success");
      } else {
        log("failed");
      }
    } catch (e, st) {
      log('sentNotification Error : $e $st');
    }
  }

  void configureDidReceiveLocalNotificationSubject() {
    log('configureDidReceiveLocalNotificationSubject stream listen');
    didReceiveLocalNotificationStream
        .listen((ReceivedNotification receivedNotification) async {
      log("payloadNotification 01: $receivedNotification");
      // notificationToNavigate();
    });
  }

  void configureSelectNotificationSubject() {
    try {
      selectNotificationStream.listen((String? payload) {
        ///call when open notification on tap
        print('receiveNotification configureSelectNotificationSubject 00');
        Map<String, dynamic> data = payload != null ? json.decode(payload) : {};

        ///coment me
        // NavigationUtils.navigationSwitch(data);
      });
    } catch (e, st) {
      log('configureSelectNotificationSubject : $e,$st');
    }
  }

  void localNotificationDispose() {
    _didReceiveLocalNotificationSubject.close();
    _selectNotificationSubject.close();
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
