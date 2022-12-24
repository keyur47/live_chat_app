import 'dart:io';

import 'package:chat_app/core/exception/exceptions.dart';
import 'package:chat_app/modules/onboarding/controller/onboading_controller.dart';
import 'package:chat_app/modules/welcome/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static FirebaseFirestore collectionReference = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  static final FirebaseHelper _firebaseService = FirebaseHelper._internal();

  factory FirebaseHelper() {
    return _firebaseService;
  }

  static Future<void> updateProfile({UserModel? userModel}) async {
    try {
      print("userId-->${OnBodingController.to.userModel.value.uid}");
      collectionReference
          .collection('UserData')
          .doc(OnBodingController.to.userModel.value.uid)
          .set({
        "fullName": userModel?.fullName,
        "age": userModel?.age,
        "imageUrl": userModel?.imageUrl,
      }, SetOptions(merge: true)).catchError((exception, stack) {
        throw AppException.showException(exception, stack);
      });
    } catch (exception, stack) {
      throw AppException.showException(exception, stack);
    }
  }

  static Future<String> updateProfilePic({String? picUrl}) async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("userImage/${DateTime.now().millisecondsSinceEpoch}")
        .putFile(
          File(picUrl!),
        );
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    print("imageurl-->${imageUrl}");

    //  DocumentReference documentReferencer = collectionReference.doc(uid!);
    print('URL===:$imageUrl');
    return imageUrl;
  }

  FirebaseHelper._internal();
}
