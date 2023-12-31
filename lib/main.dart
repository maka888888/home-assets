import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/theme.dart';
import 'package:home_assets3/ui/loading/loading_main.dart';
import 'package:home_assets3/ui/welcome/privacy_policy.dart';
import 'package:home_assets3/ui/welcome/welcome_main.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Home Assets',
        theme: homeAssetsThemeLight,
        darkTheme: homeAssetsThemeDark,
        debugShowCheckedModeBanner: false,
        routes: {
          '/privacy': (context) => const PrivacyPolicyScreen(),
        },
        navigatorObservers: <NavigatorObserver>[observer],
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasData) {
              return const LoadingScreen();
            } else if (snapshot.hasError) {
              return const Scaffold(
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ));
  }
}
