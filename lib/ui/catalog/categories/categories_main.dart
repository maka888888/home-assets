import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/categories_model.dart';

import '../../../providers/assets_provider.dart';
import '../../../providers/categories_provider.dart';
import 'category_card.dart';
import 'category_new.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<CategoryModel> categories = ref.watch(categoriesProvider)!;
    final List<AssetModel> assets = ref.watch(assetsProvider)!;

    for (var element in categories) {
      element.numberOfAssets = assets
          .where((asset) => asset.categoryId == element.id)
          .toList()
          .length;
    }

    categories.sort((b, a) => a.numberOfAssets!.compareTo(b.numberOfAssets!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: sizes.largeScreenSize,
              ),
              child: ListView.separated(
                itemCount: categories.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return CategoryCard(category: categories[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CategoryNewScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
