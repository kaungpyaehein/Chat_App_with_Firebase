import 'package:chat_app/bloc/chat_details_bloc.dart';
import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

GlobalKey<FormState> chatFormKey = GlobalKey();

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key, required this.userToChat});
  final UserVO userToChat;

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  final TextEditingController messageInputController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatDetailsBloc(widget.userToChat.id),
      child: Scaffold(
        appBar: buildDefaultAppBar(widget.userToChat.name, true),
        body: Stack(
          children: [
            ListView.builder(
              itemBuilder: (context, index) {

              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70,
                width: double.infinity,
                color: Colors.white,
                child: Form(
                  key: chatFormKey,
                  child: TextFormField(
                    controller: messageInputController,
                    decoration: InputDecoration(
                      fillColor: kTextFieldFilledColor,
                      filled: true,
                      hintText: "Write a new message",
                      hintStyle: const TextStyle(color: kHintTextColor),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kMarginSmall),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(kMarginSmall),
                          borderSide: BorderSide.none),
                      isDense: true, // Added this
                      contentPadding: const EdgeInsets.all(kMarginMedium),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.send_rounded,
                          color: kPrimaryColor,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add_circle_outlined,
                          color: kPrimaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                    onFieldSubmitted: (value) {},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
