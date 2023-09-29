import 'package:flutter/material.dart';

import '../../../models/maintainer_model.dart';
import 'maintainer_edit.dart';

class MaintainerCard extends StatelessWidget {
  final MaintainerModel maintainer;
  const MaintainerCard({super.key, required this.maintainer});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(maintainer.maintainerName),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaintainerEdit(maintainer: maintainer),
            ),
          );
        },
      ),
    );
  }
}
