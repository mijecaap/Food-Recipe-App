import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipez/User/model/user.dart';
import 'package:recipez/User/repository/cloud_firestore_api.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();

  void updateUserDataFirestore(UserModel user) => _cloudFirestoreAPI.updateUserData(user);

  Future<UserModel> readUserData(String uid) => _cloudFirestoreAPI.readData(uid);

  void updateSubscriptionData(String uid, bool subscription, String number) => _cloudFirestoreAPI.updateSubscriptionData(uid, subscription, number);
}