import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/categories_model.dart';

class CategoriesProvider extends StateNotifier<List<CategoryModel>?> {
  CategoriesProvider() : super(null);

  CollectionReference fireCategories =
      FirebaseFirestore.instance.collection('categories');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllCategories() async {
    List<CategoryModel> categories = [];
    try {
      await fireCategories
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            categories.add(CategoryModel.fromFire(element));
          }
        }
        state = categories;
      });
    } catch (error) {
      print("Failed to get categories: $error");
    }
  }

  Future createCategory(CategoryModel category) async {
    try {
      await fireCategories.add(category.toJson()).then((value) {
        category.id = value.id;
        category.createdAt = DateTime.now();
        category.updatedAt = DateTime.now();
        category.uid = user.uid;
        List<CategoryModel> newCategories = List.from(state!)..add(category);
        state = newCategories;
      });
    } catch (error) {
      print("Failed to add category: $error");
    }
  }

  Future updateCategory(CategoryModel category) async {
    try {
      category.updatedAt = DateTime.now();
      await fireCategories.doc(category.id).update(category.toJson());
      state = state!.map((e) => e.id == category.id ? category : e).toList();
    } catch (error) {
      print("Failed to update category: $error");
    }
  }

  Future deleteCategory(CategoryModel category) async {
    try {
      await fireCategories.doc(category.id).delete();
      List<CategoryModel> categories = List.from(state!);
      int index = categories.indexWhere((element) => element.id == category.id);
      if (index != -1) {
        categories.removeAt(index);
        state = categories;
      }
    } catch (error) {
      print("Failed to delete category: $error");
    }
  }

  Future deleteAllCategories() async {
    try {
      await fireCategories
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            fireCategories.doc(element.id).delete();
          }
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete categories: $error");
    }
  }

  Future createInitialCategoriesList() async {
    List<String> initialCategories = [
      'Electronics',
      'Appliances',
      'Furniture',
      'Kitchenware',
      'Outdoor & Garden',
      'Sports & Fitness Equipment',
      'Personal Items',
    ];

    state = [];

    for (var element in initialCategories) {
      CategoryModel category = CategoryModel(
        id: '',
        categoryName: element,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        uid: user.uid,
      );
      await createCategory(category);
    }
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesProvider, List<CategoryModel>?>(
        (ref) => CategoriesProvider());
