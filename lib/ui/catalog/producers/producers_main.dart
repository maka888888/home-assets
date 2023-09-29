import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/ui/catalog/producers/producer_card.dart';
import 'package:home_assets3/ui/catalog/producers/producer_new.dart';

import '../../../providers/producer_provider.dart';

class ProducersScreen extends ConsumerWidget {
  const ProducersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final producers = ref.watch(producersProvider)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Producers'),
      ),
      body: ListView.separated(
        itemCount: producers.length,
        itemBuilder: (context, index) {
          return ProducerCard(producer: producers[index]);
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
              builder: (context) => const ProducerNewScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
