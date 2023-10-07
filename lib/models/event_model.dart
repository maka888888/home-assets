import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  DateTime date;
  String assetId;
  String event;
  int? durationInMinutes;
  String? maintainerId;
  double? cost;
  String? notes;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  EventModel({
    required this.id,
    required this.date,
    required this.assetId,
    required this.event,
    this.durationInMinutes,
    this.maintainerId,
    this.cost,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory EventModel.fromFire(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    print(data['event']);

    return EventModel(
      id: document.id,
      date: DateTime.parse(data['date']),
      assetId: data['assetId'],
      event: data['event'],
      durationInMinutes: data['durationInMinutes'] == null
          ? null
          : int.tryParse(data['durationInMinutes'].toString()) ?? 0,
      maintainerId: data['maintainerId'],
      cost: double.tryParse(data['cost'].toString()) ?? 0,
      notes: data['notes'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      uid: data['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'assetId': assetId,
      'event': event,
      'durationInMinutes': durationInMinutes,
      'maintainerId': maintainerId,
      'cost': cost,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'uid': uid,
    };
  }
}
