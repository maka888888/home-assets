import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/categories_model.dart';

import 'category_edit.dart';

class CategoryCard extends ConsumerWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(category.categoryName),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(category.numberOfAssets.toString(),
                style: Theme.of(context).textTheme.labelMedium),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryEditScreen(category: category),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
