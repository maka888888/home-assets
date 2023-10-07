import 'package:flutter/material.dart';
import 'package:home_assets3/constants/sizes.dart' as sizes;

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > sizes.largeScreenSize
                      ? sizes.largeScreenSize
                      : constraints.maxWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Last updated: 2023-10-04',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '1. Introduction',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'Thank you for choosing Home Assets ("we", "our", or "us"). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our policy, or our practices with regards to your personal information, please contact us.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '2. Information We Collect',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'When you use the Home Assets app, we collect the following information:'),
                    const Text(
                        'Account Information. This includes your name and email address to create an account. If you choose to sign up using Google or Apple social logins, we will receive your name and email address from these services.'),
                    const Text(
                        'Asset Information. Details about your assets such as photos, purchase dates, prices, producer, model, serial number, and other related details.'),
                    const Text(
                        'Event Logs. Data related to repairs, maintenances, and upgrades of your assets, including action dates, maintainers, costs, and time taken.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '3. How We Use Your Information',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('We use your information to:'),
                    const Text('Provide, operate, and maintain our app.'),
                    const Text('Improve, personalize, and expand our app.'),
                    const Text('Understand and analyze how you use our app.'),
                    const Text(
                        'Communicate with you, either directly or through one of our partners, for customer service, to provide you with updates and other information relating to the app.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '4. Security of Your Information',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'We use Firebase as our backend, which employs security measures to protect your information. However, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '5. Third-Party Services',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'We may employ third-party companies and individuals to facilitate our Service. These third parties have access to your Personal Data only to perform these tasks on our behalf and are obligated not to disclose or use it for any other purpose.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "6. Children's Privacy",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'Our app does not address anyone under the age of 13. We do not knowingly collect personal identifiable information from children under 13.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "7. Changes to This Privacy Policy",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'We may update our Privacy Policy from time to time. Thus, we advise you to review this page periodically for any changes. These changes are effective immediately after they are posted on this page.'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "8. Contact Us",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                        'We may update our Privacy Policy from time to time. Thus, we advise you to review this page periodically for any changes. These changes are effective immediately after they are posted on this page.f you have any questions or suggestions about our Privacy Policy, do not hesitate to contact us at m.kamarauskas@gmail.com'),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
