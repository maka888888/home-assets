import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/ui/assets/asset_card.dart';

import '../../providers/assets_provider.dart';

class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assets = ref.watch(assetsProvider)!;

    if (assets.isEmpty) {
      return const Center(
        child: Text('No assets at the moment'),
      );
    } else {
      return ListView.separated(
        itemCount: assets.length,
        itemBuilder: (context, index) {
          return AssetCard(asset: assets[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    }
  }
}
