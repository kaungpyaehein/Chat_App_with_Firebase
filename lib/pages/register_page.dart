import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/validations.dart';
import 'package:chat_app/widgets/primary_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../utils/dimensions.dart';
import '../utils/utils_functions.dart';
import '../widgets/primary_text_input_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> registerFormKey = GlobalKey();

    final TextEditingController nameTextEditingController =
        TextEditingController();
    final TextEditingController emailTextEditingController =
        TextEditingController();
    final TextEditingController passwordTextEditingController =
        TextEditingController();
    final TextEditingController confirmPasswordTextEditingController =
        TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: registerFormKey,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(
              parent: NeverScrollableScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(
                  kMarginXXLarge2,
                ),

                /// Title
                buildTitleText(kRegisterLabel),

                const Gap(kMarginMedium),

                const Text(
                  kRegisterSubtitleText,
                  textAlign: TextAlign.center,
                ),

                const Gap(kMarginXXLarge2),

                /// NAME INPUT
                PrimaryTextInputField(
                  obscureText: false,
                  hintText: kEnterYourNameText,
                  controller: nameTextEditingController,
                  regExp: nameValidationRegExp,
                ),
                const Gap(kMarginLarge),

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

                /// CONFIRM PASSWORD INPUT
                PrimaryTextInputField(
                  obscureText: true,
                  hintText: kConfirmPasswordText,
                  controller: confirmPasswordTextEditingController,
                  regExp: passwordValidationRegExp,
                ),

                const Gap(kMarginLarge),

                /// CONTINUE BUTTON
                PrimaryButton(
                    label: kTextContinue,
                    onTap: () {
                      context.push(const MainPage());
                      if (registerFormKey.currentState?.validate() ?? false) {
                        debugPrint("Validating");
                      }
                    }),
                const Gap(kMarginMedium3),

                /// DONT HAVE AN ACCOUNT AND REGISTER
                Center(
                  child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                          text: kTextAlreadyHaveAccount,
                          style: TextStyle(color: kDefaultBlackColor)),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.pop();
                            },
                          text: kTextLogin,
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
    );
  }
}
