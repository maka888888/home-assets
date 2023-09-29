import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_assets3/ui/welcome/welcome_main.dart';

import '../../utils/delete_user_dialog.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Setup'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Profile'),
                      subtitle:
                          Text('You are logged with email ${user.email ?? ''}'),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut().then((value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const WelcomeScreen(),
                                ),
                                (route) => false,
                              );
                            });
                          },
                          child: const Text('LOGOUT'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.person_off_outlined),
                      title: Text('Delete Account'),
                      subtitle: Text('You can delete your account here.'),
                    ),
                    ButtonBar(
                      children: [
                        TextButton(
                          onPressed: () async {
                            await showDeleteUserDialog(context, ref);
                            // await showDialog(
                            //   context: context,
                            //   builder: (context) =>
                            //       showDeleteUserDialog(context, ref),
                            // );

                            // await FirebaseAuth.instance.signOut().then((value) {
                            //   Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(
                            //       builder: (context) => const WelcomeScreen(),
                            //     ),
                            //     (route) => false,
                            //   );
                            // });
                          },
                          child: const Text('DELETE ACCOUNT'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
