import 'package:cloud_firestore/cloud_firestore.dart';

class SellerModel {
  String id;
  String sellerName;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  SellerModel({
    required this.id,
    required this.sellerName,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory SellerModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return SellerModel(
      id: document.id,
      sellerName: data['sellerName'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerName': sellerName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
