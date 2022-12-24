import 'package:chat_app/core/service/firebase_service.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageController extends GetxController {
  RxList<UserModel> allUserList = <UserModel>[].obs;

  void getAllUserDataStreamListen() {
    FirebaseHelper.collectionReference
        .collection("UserData")
        .snapshots()
        .listen((event) {
      allUserList.clear();
      for (var element in event.docs) {
        allUserList.add(UserModel.fromMap(element.data()));
      }
    });
  }

  String timeAgo(DateTime date) {
    DateTime now = DateTime.now();
    int count = now.day - date.day;
    if (count == 0) {
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
    } else if (count == 1) {
      return "Yesterday";
    } else {
      var formatter = DateFormat('dd,MM,yyyy');
      String formattedDate = formatter.format(date);
      return formattedDate;
    }
  }
}
