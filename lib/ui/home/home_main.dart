import 'package:flutter/material.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/ui/assets/assets_main.dart';
import 'package:home_assets3/ui/events/event_new.dart';

import '../assets/asset_new.dart';
import '../catalog/catalog_main.dart';
import '../events/events_main.dart';
import '../setup/setup_main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> screens = [
    const AssetsScreen(),
    const EventsScreen(),
    const CatalogScreen(),
  ];

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: 'Assets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          label: 'Log',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.view_list_outlined),
          label: 'Catalog',
        ),
      ],
    );
  }

  Widget _navigationRail() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: NavigationRail(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        labelType: NavigationRailLabelType.all,
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: Text('Assets'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.history_outlined),
            label: Text('Log'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.view_list_outlined),
            label: Text('Catalog'),
          ),
        ],
      ),
    );
  }

  Widget? _floatingActionButton() {
    switch (_currentIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AssetNewScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EventNewScreen(),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      case 2:
        return null;
      default:
        return null;
    }
  }

  Widget _smallScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Assets'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SetupScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _largeScreen() {
    return Scaffold(
      body: Row(
        children: [
          _navigationRail(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Home Assets'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetupScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings_outlined),
                  )
                ],
              ),
              body: screens[_currentIndex],
            ),
          ),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > sizes.largeScreenSize) {
          return _largeScreen();
        } else {
          return _smallScreen();
        }
      },
    );
  }
}
