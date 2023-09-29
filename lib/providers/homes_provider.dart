import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/home_model.dart';

class HomesProvider extends StateNotifier<List<HomeModel>?> {
  HomesProvider() : super(null);

  CollectionReference homesCategories =
      FirebaseFirestore.instance.collection('homes');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllHomes() async {
    try {
      await homesCategories
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          List<HomeModel> homes = [];
          for (var element in value.docs) {
            homes.add(HomeModel.fromFire(element));
          }
          state = homes;
        } else {
          state = [];
        }
      });
    } catch (error) {
      print("Failed to get homes: $error");
    }
  }

  Future createHome(HomeModel home) async {
    try {
      await homesCategories.add(home.toJson()).then((value) {
        home.id = value.id;
        home.createdAt = DateTime.now();
        home.updatedAt = DateTime.now();
        home.uid = user.uid;
        List<HomeModel> newHomes = List.from(state!)..add(home);
        state = newHomes;
      });
    } catch (error) {
      print("Failed to add home: $error");
    }
  }

  Future updateHome(HomeModel home) async {
    try {
      home.updatedAt = DateTime.now();
      await homesCategories.doc(home.id).update(home.toJson());
      state = state!.map((e) => e.id == home.id ? home : e).toList();
    } catch (error) {
      print("Failed to update home: $error");
    }
  }

  Future deleteHome(HomeModel home) async {
    try {
      await homesCategories.doc(home.id).delete();
      state = state!.where((element) => element.id != home.id).toList();
    } catch (error) {
      print("Failed to delete home: $error");
    }
  }

  Future deleteAllHomes() async {
    try {
      await homesCategories
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all homes: $error");
    }
  }

  Future createInitialHome() async {
    try {
      HomeModel home = HomeModel(
        id: '',
        homeName: 'My Home',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        uid: user.uid,
      );
      state = [];
      await createHome(home);
    } catch (error) {
      print("Failed to create initial home: $error");
    }
  }
}

final homesProvider =
    StateNotifierProvider<HomesProvider, List<HomeModel>?>((ref) {
  return HomesProvider();
});
