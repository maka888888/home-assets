import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/categories_model.dart';

import '../../../providers/categories_provider.dart';

class CategoryNewScreen extends ConsumerStatefulWidget {
  const CategoryNewScreen({super.key});

  @override
  CategoryNewScreenState createState() => CategoryNewScreenState();
}

class CategoryNewScreenState extends ConsumerState<CategoryNewScreen> {
  late CategoryModel _category;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    DateTime now = DateTime.now();
    _category = CategoryModel(
      id: '',
      categoryName: '',
      createdAt: now,
      updatedAt: now,
      uid: user.uid,
    );
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref
        .read(categoriesProvider.notifier)
        .createCategory(_category)
        .then((value) {
      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Category'),
        actions: [
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
