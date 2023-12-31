import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/producers_model.dart';

class ProducersProvider extends StateNotifier<List<ProducerModel>?> {
  ProducersProvider() : super(null);

  CollectionReference fireProducers =
      FirebaseFirestore.instance.collection('producers');

  User user = FirebaseAuth.instance.currentUser!;

  Future getAllProducers() async {
    try {
      await fireProducers.where('uid', isEqualTo: user.uid).get().then((value) {
        if (value.docs.isNotEmpty) {
          List<ProducerModel> producers = [];
          for (var element in value.docs) {
            producers.add(ProducerModel.fromFire(element));
          }
          state = producers;
        } else {
          state = [];
        }
      });
      debugPrint("producers received: ${state!.length}");
    } catch (error) {
      print("Failed to get producers: $error");
    }
  }

  Future<ProducerModel> createProducer(ProducerModel producer) async {
    producer.createdAt = DateTime.now();
    producer.updatedAt = DateTime.now();
    producer.uid = user.uid;
    try {
      DocumentReference docRef = await fireProducers.add(producer.toJson());
      producer.id = docRef.id;
      List<ProducerModel> newProducers = List.from(state!)..add(producer);
      state = newProducers;
      return producer;
    } catch (error) {
      throw Exception("Failed to add producer: $error");
    }
  }

  Future updateProducer(ProducerModel producer) async {
    try {
      producer.updatedAt = DateTime.now();
      await fireProducers.doc(producer.id).update(producer.toJson());
      state = state!.map((e) => e.id == producer.id ? producer : e).toList();
    } catch (error) {
      print("Failed to update producer: $error");
    }
  }

  Future deleteProducer(ProducerModel producer) async {
    try {
      await fireProducers.doc(producer.id).delete();
      state = state!.where((element) => element.id != producer.id).toList();
    } catch (error) {
      print("Failed to delete producer: $error");
    }
  }

  Future deleteAllProducers() async {
    try {
      await fireProducers.where('uid', isEqualTo: user.uid).get().then((value) {
        for (var element in value.docs) {
          fireProducers.doc(element.id).delete();
        }
      });
      state = [];
    } catch (error) {
      print("Failed to delete all producers: $error");
    }
  }

  Future createInitialProducersList() async {
    List<String> producers = [
      'Sony',
      'Samsung',
      'Xiaomi',
      'Apple',
      'Dell',
      'LG',
      'Panasonic',
      'Bosch',
      'Philips',
      'Dyson',
      'Whirlpool',
      'Lenovo',
      'Canon',
      'Hewlett-Packard (HP)',
      'Asus',
    ];

    state = [];

    for (var element in producers) {
      ProducerModel producer = ProducerModel(
        id: '',
        producerName: element,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        uid: user.uid,
      );
      await createProducer(producer);
    }
  }
}

final producersProvider =
    StateNotifierProvider<ProducersProvider, List<ProducerModel>?>(
        (ref) => ProducersProvider());
