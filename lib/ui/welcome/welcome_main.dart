import 'package:flutter/material.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:home_assets3/ui/welcome/privacy_policy.dart';

import 'login_providers_list.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.3,
            image: AssetImage(
              'assets/images/welcome_background.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > sizes.largeScreenSize
                        ? sizes.largeScreenSize
                        : constraints.maxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Text(
                        'Home Assets',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Home Inventory, Simplified',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 60),
                      const SizedBox(
                        width: 350,
                        child: LoginProvidersWidget(),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                        // style: TextButton.styleFrom(
                        //   foregroundColor: Colors.white,
                        //),
                        child: const Text('Privacy Policy'),
                      ),
                      // TextButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) =>
                      //             const TermsOfServiceScreen(),
                      //       ),
                      //     );
                      //   },
                      //   style: TextButton.styleFrom(
                      //     foregroundColor: Colors.white,
                      //   ),
                      //   child: const Text('Terms of Service'),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
