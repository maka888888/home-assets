import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String categoryName;
  int? numberOfAssets;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  CategoryModel({
    required this.id,
    required this.categoryName,
    this.numberOfAssets,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory CategoryModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return CategoryModel(
      id: document.id,
      categoryName: data['categoryName'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryName': categoryName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
