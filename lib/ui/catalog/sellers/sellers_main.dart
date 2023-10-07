import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/ui/catalog/sellers/seller_card.dart';
import 'package:home_assets3/ui/catalog/sellers/seller_new.dart';

import '../../../providers/seller_provider.dart';

class SellersScreen extends ConsumerWidget {
  const SellersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellers = ref.watch(sellersProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sellers'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: sizes.largeScreenSize,
              ),
              child: ListView.separated(
                itemCount: sellers.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return SellerCard(seller: sellers[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SellerNewScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
