import 'dart:developer';

import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/chat/models/chate_model.dart';
import 'package:chat_app/modules/messege/model/message_model.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:chat_app/modules/welcome/screen/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController {
  TextEditingController messageController = TextEditingController();
  RxBool isAudio = false.obs;
  RxString audioMsgId = "".obs;

  void sendMessage(UserModel currentUser, ChatRoomModel chatRoom) async {
    String msg = messageController.text.trim();
    print("current user name--->>>>>${currentUser.fullName}");
    print("current user uid--->>>>${currentUser.uid}");
    if (msg != "") {
      // Send Message
      MessageModel newMessage = MessageModel(
          messageId: uuid.v1(),
          sender: currentUser.uid.toString(),
          createOn: DateTime.now(),
          text: msg,
          seen: false,
          isAudioCall: isAudio.value,
          userName: currentUser.fullName.toString());

      FirebaseHelper.collectionReference
          .collection("ChatRoom")
          .doc(chatRoom.chatroomid.toString())
          .collection("messages")
          .doc(newMessage.messageId)
          .set(newMessage.toJson());

      chatRoom.lastMessage = msg;
      chatRoom.lastMessageTime = DateTime.now();
      FirebaseFirestore.instance
          .collection("ChatRoom")
          .doc(chatRoom.chatroomid)
          .set(chatRoom.toMap(), SetOptions(merge: true));

      log("Message Sent!");
      messageController.clear();
    }
  }

  bool shouldShowDate(
      Timestamp previousMessage, Timestamp currentMessage, listMessage) {
    String previousMessageDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(
            previousMessage.millisecondsSinceEpoch))
        .toLowerCase();
    String currentMessageDate = DateFormat('dd-MM-yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(
            currentMessage.millisecondsSinceEpoch))
        .toLowerCase();
    if (listMessage != null) {
      if (currentMessageDate != previousMessageDate) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  void deleteMessage(String chatroomId, String messageId) {
    FirebaseHelper.collectionReference
        .collection('ChatRoom')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId)
        .delete()
        .then((_) {
      print(" delete success!");
      messageController.clear();

      Get.back();
    });
  }

  String timewithAmPm(DateTime date) {
    /// show only time
    // String time = DateFormat('hh:mm')
    //     .format(currentMessage.createOn as DateTime);
    String? amPm;
    var formatter = DateFormat(
      'hh:mm',
    );
    int hours = date.hour;
    if (hours > 12) {
      amPm = "PM";
    } else {
      amPm = "AM";
    }
    String formattedDate = "${formatter.format(date)}$amPm";
    return formattedDate;
  }

  String timeAgo(DateTime date) {
    DateTime now = DateTime.now();
    int count = now.day - date.day;
    if (count == 0) {
      return 'Today';
    } else if (count == 1) {
      return "Yesterday";
    } else {
      var formatter = DateFormat('dd,MMMM,yyyy');
      String formattedDate = formatter.format(date);
      return formattedDate;
    }
  }
}
// String timeAgo(String str) {
//   try {
//     DateTime d = DateTime.parse(str);
//     Duration diff = DateTime.now().difference(d);
//
//     if (diff.inDays >= 365) {
//       return (diff.inDays / 365).floor() == 1
//           ? "1 year ago "
//           : DateFormat('MMMM,dd,yyyy').format(d);
//     }
//     if (diff.inDays > 30) {
//       return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
//     }
//     if (diff.inDays > 0) {
//       return (diff.inDays / 7).floor() == 1
//           ? "yesterday ${DateFormat('hh:mm').format(d)}"
//           : "${(diff.inDays / 7).floor()} days ago";
//     }
//
//     if (diff.inDays > 7) {
//       return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
//     }
//
//     if (diff.inHours > 0) {
//       return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
//     }
//     if (diff.inMinutes > 0) {
//       return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
//     }
//
//     return "just now";
//   } catch (e) {
//     return e.toString();
//   }
// }
