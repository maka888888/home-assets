import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/seller_model.dart';

class SellersProvider extends StateNotifier<List<SellerModel>?> {
  SellersProvider() : super(null);

  CollectionReference fireSellers =
      FirebaseFirestore.instance.collection('sellers');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllSellers() async {
    try {
      await fireSellers.where('uid', isEqualTo: user.uid).get().then((value) {
        if (value.docs.isNotEmpty) {
          List<SellerModel> sellers = [];
          for (var element in value.docs) {
            sellers.add(SellerModel.fromFire(element));
          }
          state = sellers;
        } else {
          state = [];
        }
      });
      print("sellers received: ${state!.length}");
    } catch (error) {
      print("Failed to get sellers: $error");
    }
  }

  Future<SellerModel> createSeller(SellerModel seller) async {
    seller.createdAt = DateTime.now();
    seller.updatedAt = DateTime.now();
    seller.uid = user.uid;

    try {
      DocumentReference docRef = await fireSellers.add(seller.toJson());
      seller.id = docRef.id;
      List<SellerModel> newSellers = List.from(state!)..add(seller);
      state = newSellers;
      return seller;
    } catch (error) {
      throw Exception('Failed to create seller: $error');
    }
  }

  Future updateSeller(SellerModel seller) async {
    try {
      seller.updatedAt = DateTime.now();
      await fireSellers.doc(seller.id).update(seller.toJson());
      state = state!.map((e) => e.id == seller.id ? seller : e).toList();
    } catch (error) {
      print("Failed to update seller: $error");
    }
  }

  Future deleteSeller(SellerModel seller) async {
    try {
      await fireSellers.doc(seller.id).delete();
      state = state!.where((element) => element.id != seller.id).toList();
    } catch (error) {
      print("Failed to delete seller: $error");
    }
  }

  Future deleteAllSellers() async {
    try {
      await fireSellers.where('uid', isEqualTo: user.uid).get().then((value) {
        for (var element in value.docs) {
          fireSellers.doc(element.id).delete();
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all sellers: $error");
    }
  }

  Future createInitialSellersList() async {
    List<String> sellers = [
      'Amazon',
      'eBay',
      'Walmart',
      'Best Buy',
      'Alibaba',
      'Target',
      'Newegg',
      'Rakuten',
      'Flipkart',
      'Etsy',
    ];

    state = [];

    for (var element in sellers) {
      SellerModel seller = SellerModel(
        id: '',
        sellerName: element,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        uid: user.uid,
      );
      await createSeller(seller);
    }
  }
}

final sellersProvider =
    StateNotifierProvider<SellersProvider, List<SellerModel>?>((ref) {
  return SellersProvider();
});
