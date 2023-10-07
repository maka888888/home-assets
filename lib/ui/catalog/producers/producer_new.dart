import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/producers_model.dart';

import '../../../providers/producer_provider.dart';

class ProducerNewScreen extends ConsumerStatefulWidget {
  const ProducerNewScreen({super.key});

  @override
  ProducerNewScreenState createState() => ProducerNewScreenState();
}

class ProducerNewScreenState extends ConsumerState<ProducerNewScreen> {
  late ProducerModel _producer;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  initState() {
    super.initState();
    final User user = FirebaseAuth.instance.currentUser!;
    DateTime now = DateTime.now();
    _producer = ProducerModel(
      id: '',
      producerName: '',
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
        .read(producersProvider.notifier)
        .createProducer(_producer)
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
        title: const Text('New Producer'),
        actions: [
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
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: sizes.largeScreenSize,
              ),
              child: FormBuilder(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: [
                    FormBuilderTextField(
                      name: 'producerName',
                      decoration: const InputDecoration(
                        labelText: 'Producer Name',
                      ),
                      onChanged: (value) {
                        setState(() {
                          _producer.producerName = value!;
                        });
                      },
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.max(70),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
