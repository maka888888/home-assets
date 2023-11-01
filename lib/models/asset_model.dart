import 'package:cloud_firestore/cloud_firestore.dart';

class AssetModel {
  String id;
  String name;
  String? categoryId;
  String homeId;
  String? producerId;
  String? model;
  String? serialNumber;
  String? maintainerId;
  List<String> images;
  String? sellerId;
  DateTime? purchaseDate;
  double? purchasePrice;
  DateTime? warrantyDueDate;
  DateTime createdAt;
  DateTime updatedAt;
  String? notes;
  String uid;

  AssetModel({
    required this.id,
    required this.name,
    this.categoryId,
    required this.homeId,
    this.producerId,
    this.model,
    this.serialNumber,
    this.maintainerId,
    required this.images,
    required this.sellerId,
    this.purchaseDate,
    this.purchasePrice,
    this.warrantyDueDate,
    required this.createdAt,
    required this.updatedAt,
    this.notes,
    required this.uid,
  });

  factory AssetModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return AssetModel(
      id: document.id,
      name: data['name'],
      categoryId: data['categoryId'],
      homeId: data['homeId'],
      producerId: data['producerId'],
      model: data['model'],
      serialNumber: data['serialNumber'],
      maintainerId: data['maintainerId'],
      images: data['images'] == null
          ? []
          : List<String>.from(data['images'].map((x) => x)).toList(),
      sellerId: data['sellerId'],
      purchaseDate: data['purchaseDate'] == null
          ? null
          : DateTime.parse(data['purchaseDate']),
      purchasePrice: data['purchasePrice'] == null
          ? null
          : double.tryParse(data['purchasePrice'].toString()) ?? 0,
      warrantyDueDate: data['warrantyDueDate'] == null
          ? null
          : DateTime.parse(data['warrantyDueDate']),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      notes: data['notes'],
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
      'homeId': homeId,
      'producerId': producerId,
      'model': model,
      'serialNumber': serialNumber,
      'maintainerId': maintainerId,
      'images': images,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'sellerId': sellerId,
      'purchasePrice': purchasePrice,
      'warrantyDueDate': warrantyDueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'notes': notes,
      'uid': uid,
    };
  }
}
