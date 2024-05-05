import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/validations.dart';
import 'package:chat_app/widgets/primary_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/dimensions.dart';
import '../utils/utils_functions.dart';
import '../widgets/primary_text_input_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> loginFormKey = GlobalKey();

    final TextEditingController emailTextEditingController =
        TextEditingController();
    final TextEditingController passwordTextEditingController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
          child: Form(
            key: loginFormKey,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(
                  parent: NeverScrollableScrollPhysics()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(
                    kMarginXXLarge2,
                  ),

                  /// Title
                  buildTitleText(kLoginLabel),

                  const Gap(kMarginMedium),

                  const Text(
                    kLoginSubtitleText,
                    textAlign: TextAlign.center,
                  ),

                  const Gap(75),

                  /// EMAIL INPUT
                  PrimaryTextInputField(
                    obscureText: false,
                    hintText: kEnterYourEmailText,
                    controller: emailTextEditingController,
                    regExp: emailValidationRegExp,
                  ),
                  const Gap(kMarginLarge),

                  /// PASSWORD INPUT
                  PrimaryTextInputField(
                    obscureText: true,
                    hintText: kEnterYourPasswordText,
                    controller: passwordTextEditingController,
                    regExp: passwordValidationRegExp,
                  ),

                  const Gap(kMarginLarge),

                  /// CONTINUE BUTTON
                  PrimaryButton(
                      label: kTextContinue,
                      onTap: () {
                        if (loginFormKey.currentState?.validate() ?? false) {
                          debugPrint("Validating");
                        }
                      }),
                  const Gap(kMarginMedium3),

                  /// DONT HAVE AN ACCOUNT AND REGISTER
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                            text: kTextDontHaveAccount,
                            style: TextStyle(color: kDefaultBlackColor)),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.push(const RegisterPage());
                              },
                            text: kTextRegisterNow,
                            style: const TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
