import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/fire_user_model.dart';

class FireUserProvider extends StateNotifier<FireUserModel?> {
  FireUserProvider() : super(null);

  CollectionReference fireUsers =
      FirebaseFirestore.instance.collection('fireUsers');

  Future<FireUserModel?> getFireUser(String uid) async {
    try {
      QuerySnapshot snapshot =
          await fireUsers.where('uid', isEqualTo: uid).get();
      if (snapshot.docs.isNotEmpty) {
        state = FireUserModel.fromFire(snapshot.docs.first);
      }
      return state;
    } catch (error) {
      print("Failed to get user: $error");
      return null;
    }
  }

  Future createFireUser(FireUserModel fireUser) async {
    await fireUsers.add(fireUser.toJson()).then((value) {
      fireUser.id = value.id;
      state = fireUser;
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }

  Future updateFireUser(FireUserModel fireUser) async {
    await fireUsers.doc(fireUser.id).update(fireUser.toJson()).then((value) {
      state = fireUser;
    }).catchError((error) {
      print("Failed to update user: $error");
    });
  }

  Future deleteFireUser() async {
    await fireUsers.doc(state!.id).delete().then((value) {
      state = null;
    }).catchError((error) {
      print("Failed to delete user: $error");
    });
  }
}

final fireUserProvider =
    StateNotifierProvider<FireUserProvider, FireUserModel?>(
        (ref) => FireUserProvider());
