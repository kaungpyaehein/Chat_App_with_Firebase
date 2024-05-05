import 'package:chat_app/utils/strings.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class PrimaryTextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final RegExp regExp;
  final bool obscureText;
  const PrimaryTextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.regExp,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: kTextFieldFilledColor,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: kHintTextColor),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kMarginSmall),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kMarginSmall),
            borderSide: BorderSide.none),
        isDense: true, // Added this
        contentPadding: const EdgeInsets.all(kMarginMedium),
      ),
      validator: (value) {
        switch (hintText) {
          case kEnterYourPasswordText:
          case kConfirmPasswordText:
          case kCreatePasswordText:
            return regExp.hasMatch(value ?? "")
                ? null
                : "Enter a valid password";
          case kEnterYourEmailText:
            return regExp.hasMatch(value ?? "") ? null : "Enter a valid email";
          case kEnterYourNameText:
            return value != null && value.isNotEmpty
                ? null
                : "Enter a valid name";
          default:
            return "Enter a valid input";
        }
      },
    );
  }
}
