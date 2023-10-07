import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;

import '../../../models/home_model.dart';
import '../../../providers/homes_provider.dart';

class HomeEditScreen extends ConsumerStatefulWidget {
  final HomeModel home;
  const HomeEditScreen({super.key, required this.home});

  @override
  HomeEditScreenState createState() => HomeEditScreenState();
}

class HomeEditScreenState extends ConsumerState<HomeEditScreen> {
  late HomeModel _home;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _home = widget.home;
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref.read(homesProvider.notifier).updateHome(_home).then((value) {
      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context);
    });
  }

  Future _delete() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Home'),
          content: const Text(
              'Are you sure you want to delete this home? All assets and events will be deleted. This action cannot be undone.'),
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
                    .read(homesProvider.notifier)
                    .deleteHome(_home)
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
        title: const Text('Edit Home'),
        actions: [
          TextButton(
            onPressed: () async {
              await _delete();
            },
            child: const Text(
              'DELETE',
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _save();
              }
            },
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  )
                : const Text(
                    'SAVE',
                  ),
          ),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: sizes.largeScreenSize,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'homeName',
                        decoration: const InputDecoration(
                          labelText: 'Home Name',
                        ),
                        initialValue: _home.homeName,
                        onChanged: (value) {
                          setState(() {
                            _home.homeName = value!;
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.maxLength(20),
                          FormBuilderValidators.min(5),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'street',
                        decoration: const InputDecoration(
                          labelText: 'Street',
                        ),
                        initialValue: _home.street,
                        onChanged: (value) {
                          setState(() {
                            _home.street = value!;
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(70),
                          FormBuilderValidators.min(5),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'city',
                        decoration: const InputDecoration(
                          labelText: 'City',
                        ),
                        initialValue: _home.city,
                        onChanged: (value) {
                          setState(() {
                            _home.city = value!;
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(70),
                          FormBuilderValidators.min(5),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'state',
                        decoration: const InputDecoration(
                          labelText: 'State',
                        ),
                        initialValue: _home.state,
                        onChanged: (value) {
                          setState(() {
                            _home.state = value!;
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(70),
                          FormBuilderValidators.min(5),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'zip',
                        decoration: const InputDecoration(
                          labelText: 'Zip',
                        ),
                        initialValue: _home.zip,
                        onChanged: (value) {
                          setState(() {
                            _home.zip = value!;
                          });
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.maxLength(70),
                          FormBuilderValidators.min(5),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
