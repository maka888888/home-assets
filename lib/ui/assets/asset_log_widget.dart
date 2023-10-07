import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/event_model.dart';
import 'package:home_assets3/providers/events_provider.dart';
import 'package:home_assets3/ui/events/event_main.dart';
import 'package:jiffy/jiffy.dart';

class AssetLogScreen extends ConsumerWidget {
  final AssetModel asset;
  const AssetLogScreen({Key? key, required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<EventModel> events = ref
        .watch(eventsProvider)!
        .where((element) => element.assetId == asset.id)
        .toList();

    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(Jiffy.parseFromDateTime(events[index].date).yMMMMd),
              subtitle: Text(events[index].event),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventScreen(
                        eventId: events[index].id,
                      ),
                    ),
                  );
                },
              ));
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            indent: 20,
            endIndent: 20,
            thickness: 0.5,
          );
        },
        itemCount: events.length);
  }
}
