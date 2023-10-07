import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/event_model.dart';

class EventsProvider extends StateNotifier<List<EventModel>?> {
  EventsProvider() : super(null);

  CollectionReference fireEvents =
      FirebaseFirestore.instance.collection('events');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllEvents() async {
    List<EventModel> events = [];
    try {
      await fireEvents.where('uid', isEqualTo: user.uid).get().then((value) {
        if (value.docs.isNotEmpty) {
          for (var element in value.docs) {
            events.add(EventModel.fromFire(element));
          }
        }
        state = events;
        debugPrint("events received: ${events.length}");
      });
    } catch (error) {
      print("Failed to get events: $error");
    }
  }

  Future createEvent(EventModel event) async {
    try {
      await fireEvents.add(event.toJson()).then((value) {
        event.id = value.id;
        List<EventModel> newEvents = List.from(state!)..add(event);
        state = newEvents;
      });
    } catch (error) {
      print("Failed to add event: $error");
    }
  }

  Future updateEvent(EventModel event) async {
    try {
      await fireEvents.doc(event.id).update(event.toJson());
      state = state!.map((e) => e.id == event.id ? event : e).toList();
    } catch (error) {
      print("Failed to update event: $error");
    }
  }

  Future deleteEvent(EventModel event) async {
    try {
      await fireEvents.doc(event.id).delete();
      state = state!.where((e) => e.id != event.id).toList();
    } catch (error) {
      print("Failed to delete event: $error");
    }
  }

  Future deleteEventsByAssetId(String assetId) async {
    try {
      await fireEvents.where('assetId', isEqualTo: assetId).get().then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
      state = state!.where((e) => e.assetId != assetId).toList();
    } catch (error) {
      print("Failed to delete events by assetId: $error");
    }
  }

  Future deleteAllEvents() async {
    try {
      await fireEvents.where('uid', isEqualTo: user.uid).get().then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all events: $error");
    }
  }
}

final eventsProvider = StateNotifierProvider<EventsProvider, List<EventModel>?>(
    (ref) => EventsProvider());
