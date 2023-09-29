import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/home_model.dart';

class AssetsProvider extends StateNotifier<List<AssetModel>?> {
  AssetsProvider() : super(null);

  CollectionReference fireAssets =
      FirebaseFirestore.instance.collection('assets');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllAssets() async {
    List<AssetModel> assets = [];
    try {
      await fireAssets.where('uid', isEqualTo: user.uid).get().then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            assets.add(AssetModel.fromFire(element));
          }
        }
        state = assets;
      });
    } catch (error) {
      print("Failed to get assets: $error");
    }
  }

  Future createAsset(AssetModel asset) async {
    try {
      await fireAssets.add(asset.toJson()).then((value) {
        asset.id = value.id;
        asset.createdAt = DateTime.now();
        asset.updatedAt = DateTime.now();
        asset.uid = user.uid;
        List<AssetModel> newAssets = List.from(state!)..add(asset);
        state = newAssets;
      });
    } catch (error) {
      print("Failed to add asset: $error");
    }
  }

  Future updateAsset(AssetModel asset) async {
    try {
      asset.updatedAt = DateTime.now();
      await fireAssets.doc(asset.id).update(asset.toJson());
      state = state!.map((e) => e.id == asset.id ? asset : e).toList();
    } catch (error) {
      print("Failed to update asset: $error");
    }
  }

  Future deleteAsset(AssetModel asset) async {
    try {
      await fireAssets.doc(asset.id).delete();
      state = state!.where((element) => element.id != asset.id).toList();
    } catch (error) {
      print("Failed to delete asset: $error");
    }
  }

  Future deleteAssetsOfTheHome(HomeModel home) async {
    try {
      await fireAssets
          .where('uid', isEqualTo: user.uid)
          .where('homeId', isEqualTo: home.id)
          .get()
          .then((value) {
        for (var element in value.docs) {
          fireAssets.doc(element.id).delete();
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all assets: $error");
    }
  }

  Future deleteAllAssets() async {
    try {
      await fireAssets.where('uid', isEqualTo: user.uid).get().then((value) {
        for (var element in value.docs) {
          fireAssets.doc(element.id).delete();
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all assets: $error");
    }
  }
}

final assetsProvider = StateNotifierProvider<AssetsProvider, List<AssetModel>?>(
    (ref) => AssetsProvider());
