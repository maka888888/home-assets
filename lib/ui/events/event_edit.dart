import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;

import '../../constants/events.dart';
import '../../constants/times.dart';
import '../../models/event_model.dart';
import '../../providers/assets_provider.dart';
import '../../providers/events_provider.dart';
import '../../providers/maintainers_provider.dart';
import '../catalog/maintainers/maintainer_new.dart';

class EventEditScreen extends ConsumerStatefulWidget {
  final EventModel event;
  const EventEditScreen({super.key, required this.event});

  @override
  EventEditScreenState createState() => EventEditScreenState();
}

class EventEditScreenState extends ConsumerState<EventEditScreen> {
  late EventModel _event;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  Future _save() async {
    setState(() {
      _isSaving = true;
    });
    await ref.read(eventsProvider.notifier).updateEvent(_event).then((value) {
      setState(() {
        _isSaving = false;
      });
      Navigator.pop(context);
    });
  }

  Future<void> _delete() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: const Text('Are you sure you want to delete this event?'),
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
                    .read(eventsProvider.notifier)
                    .deleteEvent(_event)
                    .then((value) {
                  Navigator.pop(context);
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
        title: const Text('Edit Event'),
        actions: [
          TextButton(
            onPressed: () async {
              await _delete();
            },
            child: const Text(
              'DELETE',
            ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    children: [
                      FormBuilderDateTimePicker(
                        name: 'date',
                        inputType: InputType.date,
                        decoration: const InputDecoration(
                          labelText: 'Date',
                        ),
                        initialValue: _event.date,
                        onChanged: (value) {
                          _event.date = value!;
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderDropdown(
                        name: 'assetId',
                        decoration: const InputDecoration(
                          labelText: 'Asset',
                        ),
                        initialValue: _event.assetId,
                        items: ref
                            .watch(assetsProvider)!
                            .map((asset) => DropdownMenuItem(
                                  value: asset.id,
                                  child: Text(asset.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _event.assetId = value!;
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderDropdown(
                        name: 'event',
                        decoration: const InputDecoration(
                          labelText: 'Event',
                        ),
                        initialValue: _event.event,
                        items: events
                            .map((event) => DropdownMenuItem(
                                  value: event,
                                  child: Text(event),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _event.event = value!;
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      FormBuilderDropdown(
                        name: 'durationInMinutes',
                        decoration: const InputDecoration(
                          labelText: 'Duration',
                        ),
                        initialValue: _event.durationInMinutes,
                        items: timeNeededList
                            .map((time) => DropdownMenuItem(
                                  value: time.timeMinutes,
                                  child: Text(time.timeString),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _event.durationInMinutes = value!;
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
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
                                    _formKey
                                        .currentState!.fields['maintainerId']!
                                        .reset();
                                    _formKey
                                        .currentState!.fields['maintainerId']!
                                        .didChange(null);
                                    setState(() {
                                      _event.maintainerId = null;
                                    });
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                        ),
                        initialValue: _event.maintainerId,
                        items: ref
                            .watch(maintainersProvider)!
                            .map((maintainer) => DropdownMenuItem(
                                  value: maintainer.id,
                                  child: Text(maintainer.maintainerName),
                                ))
                            .toList(),
                        onChanged: (value) {
                          _event.maintainerId = value.toString();
                        },
                      ),
                      FormBuilderTextField(
                        name: 'cost',
                        decoration: const InputDecoration(
                          labelText: 'Cost',
                        ),
                        initialValue: _event.cost.toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          _event.cost = double.tryParse(value!);
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.numeric(),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'notes',
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                        ),
                        initialValue: _event.notes,
                        maxLines: 5,
                        minLines: 2,
                        onChanged: (value) {
                          _event.notes = value;
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
