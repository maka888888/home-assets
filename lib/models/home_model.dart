import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModel {
  String id;
  String homeName;
  String? street;
  String? city;
  String? state;
  String? zip;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  HomeModel({
    required this.id,
    required this.homeName,
    this.street,
    this.city,
    this.state,
    this.zip,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory HomeModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return HomeModel(
      id: document.id,
      homeName: data['homeName'],
      street: data['street'],
      city: data['city'],
      state: data['state'],
      zip: data['zip'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'homeName': homeName,
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
