import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/models/asset_model.dart';
import 'package:home_assets3/models/event_model.dart';
import 'package:home_assets3/providers/homes_provider.dart';
import 'package:home_assets3/ui/assets/assets_main.dart';
import 'package:home_assets3/ui/events/event_new.dart';
import 'package:home_assets3/ui/feedback/feedback_main.dart';

import '../../providers/assets_provider.dart';
import '../../providers/categories_provider.dart';
import '../assets/asset_new.dart';
import '../catalog/catalog_main.dart';
import '../events/events_main.dart';
import '../setup/setup_main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
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
    return NavigationRail(
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
    );
  }

  Widget? _floatingActionButton() {
    User user = FirebaseAuth.instance.currentUser!;
    List<AssetModel>? assets = ref.read(assetsProvider);

    AssetModel asset = AssetModel(
      id: '',
      name: '',
      categoryId: ref.read(categoriesProvider)!.first.id,
      homeId: ref.read(homesProvider)!.first.id,
      images: [],
      purchaseDate: DateTime.now(),
      purchasePrice: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      uid: user.uid,
    );

    switch (_currentIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssetNewScreen(
                  asset: asset,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
        );
      case 1:
        if (assets!.isEmpty) {
          return null;
        } else {
          EventModel event = EventModel(
            id: '',
            date: DateTime.now(),
            assetId: assets!.first.id,
            event: 'Repair',
            durationInMinutes: 60,
            maintainerId: null,
            cost: 0,
            notes: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            uid: user.uid,
          );

          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventNewScreen(
                    event: event,
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        }

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
                  builder: (context) => const FeedbackScreen(),
                ),
              );
            },
            icon: const Icon(Icons.speaker_notes_outlined),
          ),
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
      appBar: AppBar(
          title: const Text('Home Assets'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FeedbackScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.speaker_notes_outlined),
            ),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: Divider(
              indent: 100,
              thickness: 1,
              height: 1,
            ),
          )),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _navigationRail(),
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth < sizes.largeScreenSize) {
                      return screens[_currentIndex];
                    } else {
                      return ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: sizes.largeScreenSize,
                          ),
                          child: screens[_currentIndex]);
                    }
                  }),
                ),
              ),
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
