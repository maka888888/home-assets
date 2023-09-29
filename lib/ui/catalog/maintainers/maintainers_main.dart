import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/ui/catalog/maintainers/maintainer_card.dart';
import 'package:home_assets3/ui/catalog/maintainers/maintainer_new.dart';

import '../../../providers/maintainers_provider.dart';

class MaintainersScreen extends ConsumerWidget {
  const MaintainersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final maintainerList = ref.watch(maintainersProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintainers'),
      ),
      body: ListView.separated(
        itemCount: maintainerList.length,
        itemBuilder: (context, index) {
          return MaintainerCard(maintainer: maintainerList[index]);
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
              builder: (context) => const MaintainerNewScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
