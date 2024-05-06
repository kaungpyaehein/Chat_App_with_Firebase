import 'package:chat_app/bloc/auth_bloc.dart';
import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/pages/auth_page.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/validations.dart';
import 'package:chat_app/widgets/primary_button_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../data/vos/user_vo.dart';
import '../network/data_agents/chat_app_data_agent.dart';
import '../network/data_agents/chat_app_data_agent_impl.dart';
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

    return ChangeNotifierProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
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
                    Selector<AuthBloc, UserVO?>(
                        selector: (context, bloc) => bloc.currentUser,
                        builder: (context, currentUser, child) {
                          if (currentUser != null &&
                              currentUser.id!.isNotEmpty) {
                            Future.delayed(const Duration(milliseconds: 500))
                                .then((value) {
                              context.pushReplacement(const AuthPage());
                            });
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return PrimaryButton(
                              label: kTextContinue,
                              onTap: () {
                                if (loginFormKey.currentState?.validate() ??
                                    false) {
                                  context.read<AuthBloc>().login(
                                    emailTextEditingController.text.trim(),
                                    passwordTextEditingController.text
                                        .trim(),
                                  );
                                }
                              },
                            );
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
      ),
    );
  }
}
