import 'package:flutter/material.dart';
import 'package:home_assets3/models/home_model.dart';

import 'home_edit.dart';

class HomeCard extends StatelessWidget {
  final HomeModel home;
  const HomeCard({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(home.homeName),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeEditScreen(home: home),
            ),
          );
        },
      ),
    );
  }
}
