import 'package:chat_app/bloc/auth_bloc.dart';
import 'package:chat_app/data/models/chat_app_model.dart';
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
import '../utils/dimensions.dart';
import '../utils/utils_functions.dart';
import '../widgets/primary_text_input_field.dart';
import 'auth_page.dart';

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
    return ChangeNotifierProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
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

                  Selector<AuthBloc, UserVO?>(
                      selector: (context, bloc) => bloc.currentUser,
                      builder: (context, currentUser, child) {
                        if (currentUser != null && currentUser.id!.isNotEmpty) {
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
                              if ((registerFormKey.currentState?.validate() ??
                                      false) &&
                                  passwordTextEditingController.text.trim() ==
                                      confirmPasswordTextEditingController.text
                                          .trim()) {
                                context
                                    .read<AuthBloc>()
                                    .register(
                                        nameTextEditingController.text,
                                        emailTextEditingController.text.trim(),
                                        passwordTextEditingController.text
                                            .trim())
                                    .catchError((error) {
                                  Fluttertoast.showToast(
                                      msg: error.toString(),
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                });
                              } else if (passwordTextEditingController.text !=
                                  confirmPasswordTextEditingController.text) {
                                Fluttertoast.showToast(
                                    msg: "Password are not the same.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
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
      ),
    );
  }
}
