import 'package:flutter/material.dart';
import 'package:home_assets3/ui/catalog/homes/homes_main.dart';
import 'package:home_assets3/ui/catalog/maintainers/maintainers_main.dart';
import 'package:home_assets3/ui/catalog/producers/producers_main.dart';
import 'package:home_assets3/ui/catalog/sellers/sellers_main.dart';

import 'categories/categories_main.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              title: const Text('Asset Categories'),
              subtitle: const Text('Manage your asset categories'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CategoriesScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            child: ListTile(
              title: const Text('Producers'),
              subtitle: const Text('Manage your producers'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProducersScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            child: ListTile(
              title: const Text('Sellers'),
              subtitle: const Text('Manage your sellers'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SellersScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            child: ListTile(
              title: const Text('Maintainers'),
              subtitle: const Text('Manage your maintainers'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaintainersScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          Card(
            child: ListTile(
              title: const Text('Homes'),
              subtitle: const Text('Manage your homes'),
              trailing: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomesScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
