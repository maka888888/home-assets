import 'package:flutter/material.dart';
import 'package:home_assets3/ui/catalog/producers/producer_edit.dart';

import '../../../models/producers_model.dart';

class ProducerCard extends StatelessWidget {
  final ProducerModel producer;
  const ProducerCard({super.key, required this.producer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(producer.producerName),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProducerEditScreen(producer: producer),
            ),
          );
        },
      ),
    );
  }
}
