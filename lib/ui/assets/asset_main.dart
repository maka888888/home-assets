import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/event_model.dart';
import 'package:home_assets3/models/home_model.dart';
import 'package:home_assets3/ui/events/event_new.dart';
import 'package:jiffy/jiffy.dart';

import '../../models/categories_model.dart';
import '../../models/maintainer_model.dart';
import '../../models/producers_model.dart';
import '../../providers/assets_provider.dart';
import '../../providers/categories_provider.dart';
import '../../providers/homes_provider.dart';
import '../../providers/maintainers_provider.dart';
import '../../providers/producer_provider.dart';
import 'asset_edit.dart';
import 'asset_gallery.dart';
import 'asset_log_widget.dart';

class AssetScreen extends ConsumerWidget {
  final String assetId;
  const AssetScreen({super.key, required this.assetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<AssetModel> assets = ref.watch(assetsProvider)!;
    AssetModel asset = assets.firstWhere((element) => element.id == assetId);

    //category
    CategoryModel? category;
    List<CategoryModel> categories = ref.read(categoriesProvider)!;
    if (asset.categoryId != null &&
        categories.indexWhere((element) => element.id == asset.categoryId) >=
            0) {
      category =
          categories.firstWhere((element) => element.id == asset.categoryId);
    }

    //home
    HomeModel? home;
    List<HomeModel> homes = ref.read(homesProvider)!;
    if (asset.homeId != null &&
        homes.indexWhere((element) => element.id == asset.homeId) >= 0) {
      home = homes.firstWhere((element) => element.id == asset.homeId);
    }

    //producer
    ProducerModel? producer;
    List<ProducerModel> producers = ref.read(producersProvider)!;
    if (asset.producerId != null &&
        producers.indexWhere((element) => element.id == asset.producerId) >=
            0) {
      producer =
          producers.firstWhere((element) => element.id == asset.producerId);
    }

    //maintainer
    MaintainerModel? maintainer;
    List<MaintainerModel> maintainers = ref.read(maintainersProvider)!;
    if (asset.maintainerId != null &&
        maintainers.indexWhere((element) => element.id == asset.maintainerId) >=
            0) {
      maintainer =
          maintainers.firstWhere((element) => element.id == asset.maintainerId);
    }

    EventModel event = EventModel(
      id: '',
      date: DateTime.now(),
      assetId: asset.id,
      event: 'Repair',
      durationInMinutes: 60,
      maintainerId: null,
      cost: 0,
      notes: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      uid: asset.uid,
    );

    Widget photoRail() {
      if (asset.images.isEmpty) {
        return const Icon(Icons.no_photography_outlined,
            size: 50, color: Colors.grey);
      } else {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssetGalleryScreen(asset: asset),
              ),
            );
          },
          child: SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: asset.images.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 200,
                  child: Image.network(
                    asset.images[index],
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
                );
              },
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AssetEditScreen(asset: asset),
                ),
              );
            },
            child: const Text('EDIT'),
          )
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
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(children: [
                  photoRail(),
                  const SizedBox(height: 10),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(asset.name),
                  ),
                  ListTile(
                    title: const Text('Category'),
                    subtitle: category == null
                        ? const SizedBox.shrink()
                        : Text(category.categoryName),
                  ),
                  ListTile(
                    title: const Text('Home'),
                    subtitle: home == null
                        ? const SizedBox.shrink()
                        : Text(home.homeName),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Producer'),
                    subtitle: producer == null
                        ? const SizedBox.shrink()
                        : Text(producer.producerName),
                  ),
                  ListTile(
                    title: const Text('Model'),
                    subtitle: Text(asset.model ?? ''),
                  ),
                  ListTile(
                    title: const Text('Serial Number'),
                    subtitle: Text(asset.serialNumber ?? ''),
                  ),
                  ListTile(
                    title: const Text('Maintainer'),
                    subtitle: maintainer == null
                        ? const SizedBox.shrink()
                        : Text(maintainer.maintainerName),
                  ),
                  ListTile(
                    title: const Text('Purchase Date'),
                    subtitle: asset.purchaseDate == null
                        ? const SizedBox.shrink()
                        : Text(Jiffy.parseFromDateTime(asset.purchaseDate!)
                            .yMMMMd),
                  ),
                  ListTile(
                    title: const Text('Purchase Price'),
                    subtitle: asset.purchasePrice == null
                        ? const SizedBox.shrink()
                        : Text(asset.purchasePrice.toString()),
                  ),
                  ListTile(
                    title: const Text('Warranty Due Date'),
                    subtitle: asset.warrantyDueDate == null
                        ? const SizedBox.shrink()
                        : Text(Jiffy.parseFromDateTime(asset.warrantyDueDate!)
                            .yMMMMd),
                  ),
                  ListTile(
                    title: const Text('Notes'),
                    subtitle: Text(asset.notes ?? ''),
                  ),
                  const Divider(),
                  ListTile(
                      title: const Text('Asset log'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventNewScreen(
                                event: event,
                              ),
                            ),
                          );
                        },
                      )),
                  AssetLogScreen(asset: asset),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
