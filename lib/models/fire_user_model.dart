import 'package:cloud_firestore/cloud_firestore.dart';

class FireUserModel {
  String id;
  String? name;
  String? email;
  String? photoUrl;
  DateTime createdAt;
  DateTime updatedAt;
  String? uid;

  FireUserModel({
    required this.id,
    required this.name,
    this.email,
    this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
    this.uid,
  });

  factory FireUserModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return FireUserModel(
      id: document.id,
      name: data['name'],
      email: data['email'],
      photoUrl: data['photoUrl'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
