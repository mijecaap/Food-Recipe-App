import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipez/User/model/user.dart';

class CloudFirestoreAPI {

  final String USERS = "users";

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  void updateUserData(UserModel user) async{
    DocumentReference ref = _db.collection(USERS).doc(user.uid);
    return ref.set({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'subscription': user.subscription,
      'myRecipes': user.myRecipes,
      'favoriteRecipes': user.favoriteRecipes
    }, SetOptions(merge: true));
  }

  Future<UserModel> readData(String uid) async {
    final ref = _db.collection(USERS).doc(uid);
    final snapshot = await ref.get();
    if (snapshot.exists){
      return UserModel.fromJson(snapshot.data()!);
    }
    return UserModel(uid: '', name: '', email: '', photoURL: '');
  }

  void updateSubscriptionData(String uid, bool subscription, String number) async {
    DocumentReference refUser = _db.collection(USERS).doc(uid);
    return refUser.update({
      'subscription': subscription,
      'idPayment': number
    });
  }

}