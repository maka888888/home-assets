import 'package:cloud_firestore/cloud_firestore.dart';

class FeedBackModel {
  String id;
  String? email;
  String message;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  FeedBackModel({
    required this.id,
    this.email,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory FeedBackModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return FeedBackModel(
      id: document.id,
      email: data['email'],
      message: data['message'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
