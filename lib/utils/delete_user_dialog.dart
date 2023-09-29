import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/providers/assets_provider.dart';
import 'package:home_assets3/providers/categories_provider.dart';
import 'package:home_assets3/providers/events_provider.dart';
import 'package:home_assets3/providers/fire_user_provider.dart';
import 'package:home_assets3/providers/homes_provider.dart';
import 'package:home_assets3/providers/maintainers_provider.dart';
import 'package:home_assets3/providers/producer_provider.dart';
import 'package:home_assets3/providers/seller_provider.dart';

import '../ui/welcome/welcome_main.dart';

Future showDeleteUserDialog(BuildContext context, WidgetRef ref) async {
  bool isDeleting = false;

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? All records will be deleted. This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isDeleting = true;
                });
                await Future.wait([
                  ref.read(assetsProvider.notifier).deleteAllAssets(),
                  ref.read(categoriesProvider.notifier).deleteAllCategories(),
                  ref.read(producersProvider.notifier).deleteAllProducers(),
                  ref.read(sellersProvider.notifier).deleteAllSellers(),
                  ref.read(homesProvider.notifier).deleteAllHomes(),
                  ref.read(maintainersProvider.notifier).deleteAllMaintainers(),
                  ref.read(eventsProvider.notifier).deleteAllEvents(),
                  ref.read(fireUserProvider.notifier).deleteFireUser(),
                ]).then((value) async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    setState(() {
                      isDeleting = false;
                    });
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  });
                });
              },
              child: isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('DELETE'),
            ),
          ],
        );
      });
    },
  );
}
