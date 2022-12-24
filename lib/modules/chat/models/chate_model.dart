import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatroomid;
  Map<String, dynamic>? participants;
  String? lastMessage;
  DateTime? lastMessageTime;

  ChatRoomModel(
      {this.chatroomid,
      this.lastMessage,
      this.participants,
      this.lastMessageTime});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomid = map["chatroomid"];
    participants = map["participants"];
    lastMessage = map["lastmessage"];
    lastMessageTime = (map['lastMessageTime'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "participants": participants,
      "chatroomid": chatroomid,
      "lastmessage": lastMessage,
      "lastMessageTime": lastMessageTime,
    };
  }
}
