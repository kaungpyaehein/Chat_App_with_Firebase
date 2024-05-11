import 'package:chat_app/bloc/chat_details_bloc.dart';
import 'package:chat_app/data/vos/message_vo.dart';
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
        body: Selector<ChatDetailsBloc, List<MessageVO>>(
            selector: (context, bloc) => bloc.allMessages,
            builder: (context, allMessages, child) {
              final ChatDetailsBloc bloc = context.read<ChatDetailsBloc>();
              return Stack(
                children: [
                  ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    reverse: true,
                    itemCount: allMessages.length,
                    itemBuilder: (context, index) {
                      if (allMessages[index].type == "text") {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (allMessages[index].senderId ==
                                    widget.userToChat.id
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: (allMessages[index].senderId ==
                                        widget.userToChat.id
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                allMessages[index].text ?? "",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.only(
                            left: 14, right: 14, top: 10, bottom: 10),
                        child: Align(
                          alignment: (allMessages[index].senderId ==
                                  widget.userToChat.id
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              fit: BoxFit.cover,
                              allMessages[index].file ?? "",
                              height: 160,
                              width: 250,
                            ),
                          ),
                        ),
                      );
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
                                borderRadius:
                                    BorderRadius.circular(kMarginSmall),
                                borderSide: BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(kMarginSmall),
                                borderSide: BorderSide.none),
                            isDense: true, // Added this
                            contentPadding: const EdgeInsets.all(kMarginMedium),
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.send_rounded,
                                color: kPrimaryColor,
                                size: 40,
                              ),
                              onPressed: () {
                                bloc.handleSendPressed(
                                    messageInputController.text);
                                messageInputController.clear();
                              },
                            ),
                            prefixIcon: IconButton(
                              onPressed: () {
                                bloc.handleImageSelection();
                              },
                              icon: const Icon(
                                Icons.add_circle_outlined,
                                color: kPrimaryColor,
                                size: 40,
                              ),
                            ),
                          ),
                          onFieldSubmitted: (value) {
                            bloc.handleSendPressed(messageInputController.text);
                            messageInputController.clear();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
