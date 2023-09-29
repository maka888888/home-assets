import 'package:cloud_firestore/cloud_firestore.dart';

class MaintainerModel {
  String id;
  String maintainerName;
  String? maintainerEmail;
  String? maintainerPhone;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  MaintainerModel({
    required this.id,
    required this.maintainerName,
    this.maintainerEmail,
    this.maintainerPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory MaintainerModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return MaintainerModel(
      id: document.id,
      maintainerName: data['maintainerName'],
      maintainerEmail: data['maintainerEmail'],
      maintainerPhone: data['maintainerPhone'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintainerName': maintainerName,
      'maintainerEmail': maintainerEmail,
      'maintainerPhone': maintainerPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
