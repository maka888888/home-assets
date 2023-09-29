import 'package:flutter/material.dart';
import 'package:home_assets3/models/categories_model.dart';

import 'category_edit.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category.categoryName),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryEditScreen(category: category),
            ),
          );
        },
      ),
    );
  }
}
