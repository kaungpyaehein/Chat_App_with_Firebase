import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/bloc/chat_details_bloc.dart';
import 'package:chat_app/data/vos/message_vo.dart';
import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';
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
        resizeToAvoidBottomInset: true,
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
                      final MessageVO message = allMessages[index];
                      final bool isCurrentUser =
                          (message.senderId == widget.userToChat.id);
                      if (message.type == "text") {
                        return TextMessageView(
                          messageVO: message,
                          isCurrentUser: isCurrentUser,
                        );
                      }
                      return ImageMessageView(
                        messageVO: message,
                        isCurrentUser: isCurrentUser,
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

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    super.key,
    required this.messageVO,
    required this.isCurrentUser,
  });

  final MessageVO messageVO;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: isCurrentUser ? 50 : 14,
          left: isCurrentUser ? 14 : 50,
          top: 10,
          bottom: 10),
      child: Align(
        alignment: (isCurrentUser ? Alignment.topLeft : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: (isCurrentUser ? Colors.blue[200] : Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                textAlign: TextAlign.start,
                messageVO.text ?? "",
                style: const TextStyle(fontSize: kTextRegular2X),
              ),
              Text(
                messageVO.getFormattedTime(),
                style: const TextStyle(
                    color: Colors.black54, fontSize: kTextXSmall),
                textAlign: TextAlign.end,
                softWrap: true,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageMessageView extends StatelessWidget {
  const ImageMessageView({
    super.key,
    required this.messageVO,
    required this.isCurrentUser,
  });

  final MessageVO messageVO;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (isCurrentUser ? Alignment.topLeft : Alignment.topRight),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: () {
              context.push(PhotoViewWidget(imageUrl: messageVO.file ?? ""));
            },
            child: CachedNetworkImage(
              imageUrl: messageVO.file ?? "",
              fit: BoxFit.cover,
              height: 160,
              width: 250,
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoViewWidget extends StatelessWidget {
  const PhotoViewWidget({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(
        imageUrl,
      ),
    );
  }
}
