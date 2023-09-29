import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../loading/loading_main.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
      ],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          if (!state.user!.emailVerified) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoadingScreen(),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoadingScreen(),
              ),
            );
          }
        }),
      ],
      headerBuilder:
          (BuildContext context, BoxConstraints constraints, double d) {
        return AppBar(
            //backgroundColor: const Color(0xFFF5F1EA),
            );
      },
      headerMaxExtent: 75,
    );
  }
}
