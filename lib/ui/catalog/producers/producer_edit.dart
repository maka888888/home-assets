import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/producers_model.dart';

import '../../../providers/producer_provider.dart';

class ProducerEditScreen extends ConsumerStatefulWidget {
  final ProducerModel producer;
  const ProducerEditScreen({super.key, required this.producer});

  @override
  ProducerEditScreenState createState() => ProducerEditScreenState();
}

class ProducerEditScreenState extends ConsumerState<ProducerEditScreen> {
  late ProducerModel _producer;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _producer = widget.producer;
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref
        .read(producersProvider.notifier)
        .updateProducer(_producer)
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
          title: const Text('Delete Producer'),
          content: const Text('Are you sure you want to delete this producer?'),
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
                    .read(producersProvider.notifier)
                    .deleteProducer(_producer)
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
        title: const Text('Edit Producer'),
        actions: [
          TextButton(
            onPressed: () async {
              await _delete();
            },
            child: const Text('DELETE'),
          ),
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _save();
              }
            },
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
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
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _producer.producerName,
                  decoration: const InputDecoration(
                    labelText: 'Producer Name',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.max(70),
                  ]),
                  onChanged: (value) {
                    setState(() {
                      _producer.producerName = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
