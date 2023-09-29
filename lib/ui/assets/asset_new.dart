import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/providers/homes_provider.dart';
import 'package:home_assets3/providers/maintainers_provider.dart';
import 'package:home_assets3/providers/producer_provider.dart';
import 'package:home_assets3/ui/catalog/maintainers/maintainer_new.dart';
import 'package:image_picker/image_picker.dart';

import '../../providers/assets_provider.dart';
import '../../providers/categories_provider.dart';
import '../../utils/photo_handling.dart';
import '../catalog/categories/category_new.dart';
import '../catalog/producers/producer_new.dart';

class AssetNewScreen extends ConsumerStatefulWidget {
  const AssetNewScreen({super.key});

  @override
  AssetNewScreenState createState() => AssetNewScreenState();
}

class AssetNewScreenState extends ConsumerState<AssetNewScreen> {
  late AssetModel _asset;
  bool _isSaving = false;
  bool _isImageLoading = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    User user = FirebaseAuth.instance.currentUser!;
    DateTime now = DateTime.now();
    _asset = AssetModel(
      id: '',
      name: '',
      categoryId: null,
      homeId: ref.read(homesProvider)![0].id,
      producerId: null,
      maintainerId: null,
      purchaseDate: now,
      purchasePrice: 0,
      images: [],
      createdAt: now,
      updatedAt: now,
      uid: user.uid,
    );
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref.read(assetsProvider.notifier).createAsset(_asset).then((value) {
      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context);
    });
  }

  Widget _photoWidget() {
    Widget photoButtons() {
      return _isImageLoading
          ? const Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            )
          : ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isImageLoading = true;
                    });
                    await uploadPicture(context, ImageSource.camera)
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          _asset.images.add(value);
                          _isImageLoading = false;
                        });
                      }
                    });
                  },
                  child: const Text('TAKE PHOTO'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isImageLoading = true;
                    });
                    await uploadPicture(context, ImageSource.gallery)
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          _asset.images.add(value);
                          _isImageLoading = false;
                        });
                      }
                    });
                  },
                  child: const Text('SELECT PHOTO'),
                ),
              ],
            );
    }

    Widget noPhotos() {
      return Column(
        children: [
          const SizedBox(height: 20),
          photoButtons(),
          const SizedBox(height: 40),
        ],
      );
    }

    Widget photoCard(String url) {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: GridTile(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  await deletePhoto(context, url).then((value) {
                    setState(() {
                      _asset.images!.remove(url);
                    });
                  });
                },
                icon: Icon(
                  Icons.highlight_remove_rounded,
                  size: 40,
                  color: Colors.grey.shade300,
                ),
              ),
            ],
          ),
          child: Image.network(
            url,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    Widget photosGrid() {
      return Column(
        children: [
          const SizedBox(height: 10),
          photoButtons(),
          const SizedBox(height: 20),
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _asset.images!.length,
            itemBuilder: (BuildContext context, int index) {
              return photoCard(_asset.images![index]);
            },
          ),
        ],
      );
    }

    if (_asset.images!.isEmpty) {
      return noPhotos();
    } else {
      return photosGrid();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Asset'),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _save();
              }
            },
            child: _isSaving
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator())
                : const Text(
                    'SAVE',
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  initialValue: _asset.name,
                  autofocus: true,
                  onChanged: (value) {
                    _asset.name = value!;
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.maxLength(70),
                    FormBuilderValidators.min(5),
                  ]),
                ),
                FormBuilderDropdown(
                  name: 'categoryId',
                  decoration: InputDecoration(
                    labelText: 'Category',
                    suffixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryNewScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  initialValue: _asset.categoryId,
                  items: ref
                      .watch(categoriesProvider)!
                      .map((category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(category.categoryName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _asset.categoryId = value.toString();
                  },
                ),
                FormBuilderDropdown(
                  name: 'homeId',
                  decoration: const InputDecoration(
                    labelText: 'Home',
                  ),
                  initialValue: _asset.homeId,
                  items: ref
                      .read(homesProvider)!
                      .map((home) => DropdownMenuItem(
                            value: home.id,
                            child: Text(home.homeName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _asset.homeId = value.toString();
                  },
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderDropdown(
                  name: 'producerId',
                  decoration: InputDecoration(
                    labelText: 'Asset Producer',
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ProducerNewScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              _formKey.currentState!.fields['producerId']!
                                  .reset();
                              _formKey.currentState!.fields['producerId']!
                                  .didChange(null);
                              setState(() {
                                _asset.producerId = null;
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  ),
                  initialValue: _asset.producerId,
                  items: ref
                      .watch(producersProvider)!
                      .map((producer) => DropdownMenuItem(
                            value: producer.id,
                            child: Text(producer.producerName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _asset.producerId = value.toString();
                  },
                ),
                FormBuilderTextField(
                  name: 'model',
                  decoration: const InputDecoration(
                    labelText: 'Model',
                  ),
                  initialValue: _asset.model,
                  onChanged: (value) {
                    _asset.model = value;
                  },
                ),
                FormBuilderTextField(
                  name: 'serialNumber',
                  decoration: const InputDecoration(
                    labelText: 'Serial Number',
                  ),
                  initialValue: _asset.serialNumber,
                  onChanged: (value) {
                    _asset.serialNumber = value;
                  },
                ),
                FormBuilderDropdown(
                  name: 'maintainerId',
                  decoration: InputDecoration(
                    labelText: 'Asset Maintainer',
                    suffixIcon: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MaintainerNewScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: () {
                              _formKey.currentState!.fields['maintainerId']!
                                  .reset();
                              _formKey.currentState!.fields['maintainerId']!
                                  .didChange(null);
                              setState(() {
                                _asset.maintainerId = null;
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                  ),
                  initialValue: _asset.maintainerId,
                  items: ref
                      .watch(maintainersProvider)!
                      .map((maintainer) => DropdownMenuItem(
                            value: maintainer.id,
                            child: Text(maintainer.maintainerName),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _asset.maintainerId = value.toString();
                  },
                ),
                FormBuilderDateTimePicker(
                  name: 'purchaseDate',
                  inputType: InputType.date,
                  decoration: InputDecoration(
                    labelText: 'Purchase Date',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _asset.purchaseDate = null;
                          _formKey.currentState!.fields['purchaseDate']!
                              .didChange(null);
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  initialValue: _asset.purchaseDate,
                  onChanged: (value) {
                    _asset.purchaseDate = value!;
                  },
                ),
                FormBuilderTextField(
                  name: 'purchasePrice',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Purchase Price',
                  ),
                  onChanged: (value) {
                    _asset.purchasePrice = double.parse(value!);
                  },
                ),
                FormBuilderDateTimePicker(
                  name: 'warrantyDueDate',
                  inputType: InputType.date,
                  initialValue: _asset.warrantyDueDate,
                  decoration: InputDecoration(
                    labelText: 'Warranty Due Date',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _asset.warrantyDueDate = null;
                          _formKey.currentState!.fields['warrantyDueDate']!
                              .didChange(null);
                        });
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                  onChanged: (value) {
                    _asset.warrantyDueDate = value;
                  },
                ),
                FormBuilderTextField(
                  name: 'notes',
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                  ),
                  initialValue: _asset.notes,
                  onChanged: (value) {
                    _asset.notes = value;
                  },
                ),
                const SizedBox(height: 20),
                _photoWidget(),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}