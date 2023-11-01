import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import '../loading/loading_main.dart';
import 'email_login.dart';

class LoginProvidersWidget extends StatelessWidget {
  const LoginProvidersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    String clientId = '';

    if (isIOS) {
      clientId =
          '454120191953-2mt5fcksbtpuh4u9g6qkr3ib7kclrkdi.apps.googleusercontent.com';
    } else {
      clientId =
          '454120191953-be27j6rsg57tjalajbql6e2u3tgmse95.apps.googleusercontent.com';
    }

    return AuthStateListener<OAuthController>(
      listener: (oldState, newState, controller) {
        //print('AuthStateListener: $oldState -> $newState');
        //print('AuthStateListener: $newState');

        if (newState is AuthFailed) {}
        if (newState is SignedIn) {
          //print('Signed in as ${newState.user?.displayName}');
          //context.pushReplacement('/');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoadingScreen(),
            ),
            (Route<dynamic> route) => false,
          );
        }
        return null;
      },
      child: Column(
        children: [
          SizedBox(
            width: 350,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EmailLoginScreen(),
                  ),
                );
              },
              child: const Text('Login with email and password'),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),
          const SizedBox(
            height: 10,
          ),
          OAuthProviderButton(
            provider: GoogleProvider(
              clientId: clientId,
            ),
          ),
          isIOS
              ? OAuthProviderButton(
                  provider: AppleProvider(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
