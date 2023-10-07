import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/seller_model.dart';

import '../../../providers/seller_provider.dart';

class SellerEditScreen extends ConsumerStatefulWidget {
  final SellerModel seller;
  const SellerEditScreen({super.key, required this.seller});

  @override
  SellerEditScreenState createState() => SellerEditScreenState();
}

class SellerEditScreenState extends ConsumerState<SellerEditScreen> {
  late SellerModel seller;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    seller = widget.seller;
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref.read(sellersProvider.notifier).updateSeller(seller).then((value) {
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
          title: const Text('Delete Seller'),
          content: const Text('Are you sure you want to delete this seller?'),
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
                    .read(sellersProvider.notifier)
                    .deleteSeller(seller)
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
        title: const Text('Edit Seller'),
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
                    width: 20, height: 20, child: CircularProgressIndicator())
                : const Text('SAVE'),
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
                  initialValue: {
                    'sellerName': seller.sellerName,
                  },
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'sellerName',
                        decoration: const InputDecoration(
                          labelText: 'Seller Name',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.max(70),
                        ]),
                        onChanged: (value) {
                          setState(() {
                            seller.sellerName = value!;
                          });
                        },
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
