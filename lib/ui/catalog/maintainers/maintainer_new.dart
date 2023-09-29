import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/maintainer_model.dart';

import '../../../providers/maintainers_provider.dart';

class MaintainerNewScreen extends ConsumerStatefulWidget {
  const MaintainerNewScreen({super.key});

  @override
  MaintainerNewScreenState createState() => MaintainerNewScreenState();
}

class MaintainerNewScreenState extends ConsumerState<MaintainerNewScreen> {
  late MaintainerModel _maintainer;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    User user = FirebaseAuth.instance.currentUser!;
    _maintainer = MaintainerModel(
      id: '',
      maintainerName: '',
      maintainerEmail: '',
      maintainerPhone: '',
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
        .read(maintainersProvider.notifier)
        .createMaintainer(_maintainer)
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
        title: const Text('New Maintainer'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.saveAndValidate()) {
                await _save();
              }
            },
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  )
                : const Text('SAVE'),
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
                  name: 'maintainerName',
                  decoration: const InputDecoration(
                    labelText: 'Maintainer Name',
                  ),
                  initialValue: _maintainer.maintainerName,
                  onChanged: (value) {
                    setState(() {
                      _maintainer.maintainerName = value!;
                    });
                  },
                  textCapitalization: TextCapitalization.words,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.min(5),
                    FormBuilderValidators.max(70),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'maintainerEmail',
                  initialValue: _maintainer.maintainerEmail,
                  decoration: const InputDecoration(
                    labelText: 'Maintainer Email',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _maintainer.maintainerEmail = value!;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                FormBuilderTextField(
                  name: 'maintainerPhone',
                  initialValue: _maintainer.maintainerPhone,
                  decoration: const InputDecoration(
                    labelText: 'Maintainer Phone',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _maintainer.maintainerPhone = value!;
                    });
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
