import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/categories_model.dart';

import '../../../providers/categories_provider.dart';

class CategoryEditScreen extends ConsumerStatefulWidget {
  final CategoryModel category;
  const CategoryEditScreen({super.key, required this.category});

  @override
  CategoryEditScreenState createState() => CategoryEditScreenState();
}

class CategoryEditScreenState extends ConsumerState<CategoryEditScreen> {
  late CategoryModel _category;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _category = widget.category;
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref
        .read(categoriesProvider.notifier)
        .updateCategory(_category)
        .then((value) {
      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context);
    });
  }

  Future _delete() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                await ref
                    .read(categoriesProvider.notifier)
                    .deleteCategory(_category)
                    .then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
        actions: [
          TextButton(
            onPressed: () async {
              await _delete();
            },
            child: const Text('DELETE'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _save();
              }
            },
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : const Text('SAVE'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _category.categoryName,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.maxLength(70),
                ]),
                onChanged: (value) {
                  setState(() {
                    _category.categoryName = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
