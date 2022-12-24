import 'package:cloud_firestore/cloud_firestore.dart';

class CallingModel {
  String? callingId;
  Map<String, dynamic>? participants;
  String? senderStatus;
  String? receiverStatus;
  String? callType;
  DateTime? createOn;
  String? senderId;

  CallingModel(
      {this.callingId,
      this.senderStatus,
      this.receiverStatus,
      this.callType,
      this.participants,
      this.senderId,
      this.createOn});

  CallingModel.fromMap(Map<String, dynamic> map) {
    callingId = map["callingId"];
    participants = map["participants"];
    senderStatus = map["senderStatus"];
    receiverStatus = map["receiverStatus"];
    callType = map["callType"];
    senderId = map["senderId"];
    createOn = (map['createOn'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() {
    return {
      "participants": participants,
      "callingId": callingId,
      "senderStatus": senderStatus,
      "receiverStatus": receiverStatus,
      "callType": callType,
      "senderId": senderId,
      "createOn": createOn,
    };
  }
}
