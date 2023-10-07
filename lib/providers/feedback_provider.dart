import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/feedback_model.dart';

class FeedBackProvider extends StateNotifier<String?> {
  FeedBackProvider() : super(null);

  CollectionReference fireFeedBacks =
      FirebaseFirestore.instance.collection('feedbacks');

  User user = FirebaseAuth.instance.currentUser!;

  Future createFeedBack(FeedBackModel feedBack) async {
    try {
      await fireFeedBacks.add({
        'email': feedBack.email,
        'message': feedBack.message,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'uid': user.uid,
      }).then((value) {
        state = 'success';
      });
    } catch (error) {
      print("Failed to add feedback: $error");
    }
  }
}

final feedBackProvider =
    StateNotifierProvider<FeedBackProvider, String?>((ref) {
  return FeedBackProvider();
});
