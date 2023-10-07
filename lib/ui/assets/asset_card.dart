import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/categories_model.dart';
import 'package:home_assets3/providers/categories_provider.dart';

import 'asset_main.dart';

class AssetCard extends ConsumerWidget {
  final AssetModel asset;
  const AssetCard({super.key, required this.asset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CategoryModel? category;
    if (asset.categoryId != null &&
        ref
                .read(categoriesProvider)!
                .indexWhere((element) => element.id == asset.categoryId) >=
            0) {
      category = ref
          .read(categoriesProvider)!
          .firstWhere((element) => element.id == asset.categoryId);
    } else {
      category = null;
    }

    return ListTile(
        title: Text(asset.name),
        subtitle: category == null ? null : Text(category.categoryName),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssetScreen(assetId: asset.id!),
              ),
            );
          },
        ));
  }
}
