import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/maintainer_model.dart';

class MaintainersProvider extends StateNotifier<List<MaintainerModel>?> {
  MaintainersProvider() : super(null);

  CollectionReference fireMaintainers =
      FirebaseFirestore.instance.collection('maintainers');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllMaintainers() async {
    List<MaintainerModel> maintainers = [];

    try {
      await fireMaintainers
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            maintainers.add(MaintainerModel.fromFire(element));
          }
        }
      });
      debugPrint("maintainers received: ${maintainers.length}");
    } catch (error) {
      print("Failed to get maintainers: $error");
    }

    state = maintainers;
  }

  Future<MaintainerModel> createMaintainer(MaintainerModel maintainer) async {
    maintainer.createdAt = DateTime.now();
    maintainer.updatedAt = DateTime.now();
    maintainer.uid = user.uid;

    try {
      DocumentReference docRef = await fireMaintainers.add(maintainer.toJson());
      maintainer.id = docRef.id;

      List<MaintainerModel> newMaintainers = List.from(state!)..add(maintainer);
      state = newMaintainers;
      return maintainer;
    } catch (error) {
      throw Exception('Failed to create maintainer: $error');
    }
  }

  Future updateMaintainer(MaintainerModel maintainer) async {
    try {
      maintainer.updatedAt = DateTime.now();
      await fireMaintainers.doc(maintainer.id).update(maintainer.toJson());
      state =
          state!.map((e) => e.id == maintainer.id ? maintainer : e).toList();
    } catch (error) {
      print("Failed to update maintainer: $error");
    }
  }

  Future deleteMaintainer(MaintainerModel maintainer) async {
    try {
      await fireMaintainers.doc(maintainer.id).delete();
      List<MaintainerModel> maintainers = List.from(state!);
      maintainers.removeWhere((element) => element.id == maintainer.id);
      state = maintainers;
    } catch (error) {
      print("Failed to delete maintainer: $error");
    }
  }

  Future deleteAllMaintainers() async {
    try {
      await fireMaintainers
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            fireMaintainers.doc(element.id).delete();
          }
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all maintainers: $error");
    }
  }
}

final maintainersProvider =
    StateNotifierProvider<MaintainersProvider, List<MaintainerModel>?>((ref) {
  return MaintainersProvider();
});
