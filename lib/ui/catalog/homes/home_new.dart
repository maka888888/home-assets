import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/home_model.dart';

import '../../../providers/homes_provider.dart';

class HomeNewScreen extends ConsumerStatefulWidget {
  const HomeNewScreen({super.key});

  @override
  HomeNewScreenState createState() => HomeNewScreenState();
}

class HomeNewScreenState extends ConsumerState<HomeNewScreen> {
  late HomeModel _home;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    DateTime now = DateTime.now();
    _home = HomeModel(
      id: '',
      homeName: '',
      createdAt: now,
      updatedAt: now,
      uid: user.uid,
    );
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref.read(homesProvider.notifier).createHome(_home).then((value) {
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
        title: const Text('New Home'),
        actions: [
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
      body: SingleChildScrollView(
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
    );
  }
}
