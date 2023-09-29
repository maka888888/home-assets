import 'package:cloud_firestore/cloud_firestore.dart';

class ProducerModel {
  String id;
  String producerName;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  ProducerModel({
    required this.id,
    required this.producerName,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory ProducerModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return ProducerModel(
      id: document.id,
      producerName: data['producerName'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'producerName': producerName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
