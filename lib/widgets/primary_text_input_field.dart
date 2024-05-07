import 'package:chat_app/utils/strings.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class PrimaryTextInputField extends StatefulWidget {
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
  State<PrimaryTextInputField> createState() => _PrimaryTextInputFieldState();
}

class _PrimaryTextInputFieldState extends State<PrimaryTextInputField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: !isVisible && widget.obscureText,
      decoration: InputDecoration(
          fillColor: kTextFieldFilledColor,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: kHintTextColor),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kMarginSmall),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(kMarginSmall),
              borderSide: BorderSide.none),
          isDense: true, // Added this
          contentPadding: const EdgeInsets.all(kMarginMedium),
          suffixIcon: widget.hintText == kEnterYourPasswordText ||
                  widget.hintText == kConfirmPasswordText ||
                  widget.hintText == kCreatePasswordText
              ? IconButton(
                  icon:
                      Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                )
              : null),
      validator: (value) {
        switch (widget.hintText) {
          case kEnterYourPasswordText:
          case kConfirmPasswordText:
          case kCreatePasswordText:
            return widget.regExp.hasMatch(value ?? "")
                ? null
                : "Enter a valid password";
          case kEnterYourEmailText:
            return widget.regExp.hasMatch(value ?? "")
                ? null
                : "Enter a valid email";
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
