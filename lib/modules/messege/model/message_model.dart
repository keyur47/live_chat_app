import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String? messageId;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createOn;
  String? replyMessage;
  String? userName;
  String replyUserName;
  bool? isAudioCall;

  MessageModel(
      {this.messageId,
      this.seen,
      this.text,
      this.sender,
      this.createOn,
      this.replyMessage = '',
      this.replyUserName = '',
      this.isAudioCall,
      this.userName});

  static MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
      messageId: json['messageId'],
      sender: json['sender'],
      text: json['text'],
      seen: json['seen'],
      createOn: (json['createOn'] as Timestamp).toDate(),
      replyMessage: json['replyMessage'] ?? '',
      userName: json['userName'],
      isAudioCall: json['isAudioCall'] ?? false,
      replyUserName: json['replyUserName'] ?? '');

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'sender': sender,
      'text': text,
      'seen': seen,
      'createOn': createOn,
      'userName': userName,
      'replyMessage': replyMessage,
      'replyUserName': replyUserName,
      'isAudioCall': isAudioCall ?? false
    };
  }
}
