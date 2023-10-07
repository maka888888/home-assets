import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/event_model.dart';
import 'package:home_assets3/models/maintainer_model.dart';
import 'package:jiffy/jiffy.dart';

import '../../constants/times.dart';
import '../../providers/assets_provider.dart';
import '../../providers/events_provider.dart';
import '../../providers/maintainers_provider.dart';
import '../assets/asset_main.dart';
import '../catalog/maintainers/maintainer_edit.dart';
import 'event_edit.dart';

class EventScreen extends ConsumerWidget {
  final String eventId;
  const EventScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<EventModel> events = ref.watch(eventsProvider)!;
    EventModel event = events.firstWhere((element) => element.id == eventId);

    AssetModel? asset;
    List<AssetModel> assets = ref.read(assetsProvider)!;
    if (event.assetId != null &&
        assets.indexWhere((element) => element.id == event.assetId) >= 0) {
      asset = assets.firstWhere((element) => element.id == event.assetId);
    }

    MaintainerModel? maintainer;
    List<MaintainerModel> maintainers = ref.read(maintainersProvider)!;
    if (event.maintainerId != null &&
        maintainers.indexWhere((element) => element.id == event.maintainerId) >=
            0) {
      maintainer =
          maintainers.firstWhere((element) => element.id == event.maintainerId);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventEditScreen(
                    event: event,
                  ),
                ),
              );
            },
            child: const Text('EDIT'),
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
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: const Text('Date'),
                    subtitle: Text(Jiffy.parseFromDateTime(event.date).yMMMMd),
                  ),
                  ListTile(
                    title: const Text('Asset'),
                    subtitle: Text(asset == null ? '' : asset.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AssetScreen(assetId: asset!.id!),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Maintainer'),
                    subtitle: Text(
                        maintainer == null ? '' : maintainer.maintainerName),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaintainerEdit(
                              maintainer: maintainer!,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Event'),
                    subtitle: Text(event.event),
                  ),
                  ListTile(
                    title: const Text('Cost'),
                    subtitle: Text(event.cost.toString()),
                  ),
                  ListTile(
                    title: const Text('Duration'),
                    subtitle: Text(
                      event.durationInMinutes == null
                          ? ''
                          : timeToText(event.durationInMinutes!),
                    ),
                  ),
                  ListTile(
                    title: const Text('Notes'),
                    subtitle: Text(event.notes ?? ''),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
