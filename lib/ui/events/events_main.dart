import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/ui/events/event_card.dart';

import '../../providers/events_provider.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider)!;
    events.sort((a, b) => b.date.compareTo(a.date));

    if (events.isEmpty) {
      return const Center(
        child: Text('No events have been registered yet'),
      );
    } else {
      return ListView.separated(
        itemCount: events.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return EventCard(event: events[index]);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      );
    }
  }
}
