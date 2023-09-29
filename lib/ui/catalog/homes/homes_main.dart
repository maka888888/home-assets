import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/ui/catalog/homes/home_card.dart';
import 'package:home_assets3/ui/catalog/homes/home_new.dart';

import '../../../providers/homes_provider.dart';

class HomesScreen extends ConsumerWidget {
  const HomesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homes = ref.watch(homesProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homes'),
      ),
      body: ListView.separated(
        itemCount: homes.length,
        itemBuilder: (context, index) {
          return HomeCard(home: homes[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeNewScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
