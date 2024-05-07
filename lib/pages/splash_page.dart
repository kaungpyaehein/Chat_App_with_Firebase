import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/images.dart';
import '../utils/utils_functions.dart';
import '../widgets/primary_button_widget.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      automaticallyImplyLeading: false,
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Gap(
                  kMarginXXLarge2,
                ),

                /// Splash Image
                Image.asset(
                  fit: BoxFit.cover,
                  kSplashImage,
                  height: 270,
                ),

                const Gap(
                  kMarginXLarge,
                ),

                /// Splash Page Label text
                buildTitleText(kSplashLabel),

                const Spacer(),

                /// Terms and Privacy Policy Text
                const Text(
                  kTermsAndPrivacyPolicyLabel,
                  style: TextStyle(
                      fontSize: kTextRegular, fontWeight: FontWeight.w500),
                ),

                /// Start Messaging Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kMargin18),
                  child: PrimaryButton(
                    label: kStartMessagingLabel,
                    onTap: () {
                      context.pushReplacement(const LoginPage());
                    },
                  ),
                ),
                const Gap(kMarginMedium2)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
