import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/maintainer_model.dart';

import '../../../providers/maintainers_provider.dart';

class MaintainerEdit extends ConsumerStatefulWidget {
  final MaintainerModel maintainer;
  const MaintainerEdit({super.key, required this.maintainer});

  @override
  MaintainerEditState createState() => MaintainerEditState();
}

class MaintainerEditState extends ConsumerState<MaintainerEdit> {
  late MaintainerModel _maintainer;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _maintainer = widget.maintainer;
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref
        .read(maintainersProvider.notifier)
        .updateMaintainer(_maintainer)
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
          title: const Text('Delete Maintainer'),
          content:
              const Text('Are you sure you want to delete this maintainer?'),
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
                    .read(maintainersProvider.notifier)
                    .deleteMaintainer(_maintainer)
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
        title: const Text('Edit Maintainer'),
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
                    child: CircularProgressIndicator(),
                  )
                : const Text('SAVE'),
          ),
        ],
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormBuilderTextField(
              name: 'maintainerName',
              decoration: const InputDecoration(
                labelText: 'Maintainer Name',
              ),
              onChanged: (value) {
                setState(() {
                  _maintainer.maintainerName = value!;
                });
              },
              initialValue: _maintainer.maintainerName,
              textCapitalization: TextCapitalization.words,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.min(5),
                FormBuilderValidators.max(70),
              ]),
            ),
            FormBuilderTextField(
              name: 'maintainerEmail',
              decoration: const InputDecoration(
                labelText: 'Maintainer Email',
              ),
              initialValue: _maintainer.maintainerEmail,
              onChanged: (value) {
                setState(() {
                  _maintainer.maintainerEmail = value!;
                });
              },
              keyboardType: TextInputType.emailAddress,
            ),
            FormBuilderTextField(
              name: 'maintainerPhone',
              decoration: const InputDecoration(
                labelText: 'Maintainer Phone',
              ),
              initialValue: _maintainer.maintainerPhone,
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
    );
  }
}
