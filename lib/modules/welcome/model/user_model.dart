class UserModel {
  String? uid;
  String? fullName;
  String? status;
  String? uniqueDeviceId;
  int? age;
  String? imageUrl;
  String? deviceToken;

  UserModel(
      {this.uid,
      this.fullName,
      this.status,
      this.uniqueDeviceId,
      this.age,
      this.imageUrl,
      this.deviceToken});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"] ?? '';
    fullName = map["fullName"] ?? '';
    uniqueDeviceId = map["uniqueDeviceId"] ?? '';
    age = map["age"] ?? 0;
    imageUrl = map["imageUrl"] ?? '';
    status = map["status"] ?? '';
    deviceToken = map["deviceToken"] ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid ?? "",
      "fullName": fullName ?? "",
      "status": status ?? "",
      "uniqueDeviceId": uniqueDeviceId ?? "",
      "age": age ?? 0,
      "imageUrl": imageUrl ?? "",
      "deviceToken": deviceToken ?? "",
    };
  }

  UserModel copyWith(
      {String? uid,
      String? fullName,
      int? age,
      String? imageUrl,
      String? deviceToken,
      String? status}) {
    return UserModel(
        uid: uid ?? this.uid,
        fullName: fullName ?? fullName,
        age: age ?? age,
        imageUrl: imageUrl ?? imageUrl,
        deviceToken: deviceToken ?? deviceToken,
        status: status ?? status);
  }
}
