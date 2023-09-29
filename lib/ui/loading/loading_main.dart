import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/fire_user_model.dart';
import 'package:home_assets3/providers/assets_provider.dart';
import 'package:home_assets3/providers/events_provider.dart';
import 'package:home_assets3/providers/homes_provider.dart';
import 'package:home_assets3/providers/maintainers_provider.dart';
import 'package:home_assets3/providers/producer_provider.dart';
import 'package:home_assets3/providers/seller_provider.dart';

import '../../providers/categories_provider.dart';
import '../../providers/fire_user_provider.dart';
import '../home/home_main.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future _load() async {
    User user = FirebaseAuth.instance.currentUser!;
    FireUserModel? fireUser =
        await ref.read(fireUserProvider.notifier).getFireUser(user.uid);

    if (fireUser == null) {
      print('Performing new user onboarding...');

      DateTime now = DateTime.now();
      FireUserModel newUser = FireUserModel(
        id: '',
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
        createdAt: now,
        updatedAt: now,
        uid: user.uid,
      );

      await ref
          .read(fireUserProvider.notifier)
          .createFireUser(newUser)
          .then((value) {
        Future.wait([
          ref.read(categoriesProvider.notifier).createInitialCategoriesList(),
          ref.read(producersProvider.notifier).createInitialProducersList(),
          ref.read(sellersProvider.notifier).createInitialSellersList(),
          ref.read(homesProvider.notifier).createInitialHome(),
          ref.read(maintainersProvider.notifier).getAllMaintainers(),
          ref.read(assetsProvider.notifier).getAllAssets(),
          ref.read(eventsProvider.notifier).getAllEvents(),
        ]).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        });
      });
    } else {
      print('User already exists, skipping onboarding...');

      await ref
          .read(fireUserProvider.notifier)
          .getFireUser(user.uid)
          .then((value) {
        Future.wait([
          ref.read(categoriesProvider.notifier).getAllCategories(),
          ref.read(producersProvider.notifier).getAllProducers(),
          ref.read(sellersProvider.notifier).getAllSellers(),
          ref.read(maintainersProvider.notifier).getAllMaintainers(),
          ref.read(homesProvider.notifier).getAllHomes(),
          ref.read(assetsProvider.notifier).getAllAssets(),
          ref.read(eventsProvider.notifier).getAllEvents(),
        ]).then((value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
