import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/event_model.dart';
import 'package:home_assets3/providers/assets_provider.dart';
import 'package:jiffy/jiffy.dart';

import 'event_main.dart';

class EventCard extends ConsumerWidget {
  final EventModel event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AssetModel asset = ref
        .read(assetsProvider)!
        .where((element) => element.id == event.assetId)
        .first;

    return ListTile(
      title: Text(Jiffy.parseFromDateTime(event.date).yMMMMd.toString()),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(asset.name),
          Text(event.event),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventScreen(eventId: event.id!),
            ),
          );
        },
      ),
    );
  }
}
