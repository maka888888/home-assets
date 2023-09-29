import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;
import 'package:video_player/video_player.dart';

import 'login_providers_list.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/home_video.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.play();
        _controller.setLooping(true);

        setState(() {});
      });
  }

  @override
  void dispose() {
    print("Disposing of VideoPlayerController");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: kIsWeb
                  ? Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                    )
                  : SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
            ),
          ),
          LayoutBuilder(
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
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .fontSize,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Home Inventory, Simplified',
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 60),
                        const SizedBox(
                          width: 350,
                          child: LoginProvidersWidget(),
                        ),
                        // const SizedBox(height: 40),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) =>
                        //             const PrivacyPolicyScreen(),
                        //       ),
                        //     );
                        //   },
                        //   style: TextButton.styleFrom(
                        //     foregroundColor: Colors.white,
                        //   ),
                        //   child: const Text('Privacy Policy'),
                        // ),
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
        ],
      ),
    );
  }
}
