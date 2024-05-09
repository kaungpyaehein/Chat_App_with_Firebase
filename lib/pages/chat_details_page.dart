import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/data/vos/message_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:chat_app/utils/colors.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'dart:convert';
import 'dart:math';

import 'package:image_picker/image_picker.dart';

import '../data/vos/user_vo.dart';

class ChatDetailsPage extends StatefulWidget {
  const ChatDetailsPage({super.key, required this.user});
  final UserVO user;
  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  ChatAppModel model = ChatAppModel();
  late UserVO currentUser;
  late types.User currentMessageSender;
  @override
  void initState() {
    currentUser = model.getUserDataFromDatabase()!;
    currentMessageSender = types.User(
      id: currentUser.id,
      firstName: currentUser.name,
    );
    super.initState();
  }

  final List<types.Message> _messages = [];

  void _handleSendPressed(types.PartialText message) {
    firebaseApi.sendMessage(
        MessageVO(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: message.text,
            file: "",
            senderName: currentUser.name,
            senderId: currentUser.id,
            type: "text"),
        currentUser.id,
        widget.user.id);
    // _addMessage(textMessage);
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: currentMessageSender,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: getRandString(10),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );
    }
  }

  final FirebaseApi firebaseApi = FirebaseApiImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(widget.user.name, true),
      body: StreamBuilder<List<MessageVO>>(
          initialData: [],
          stream: firebaseApi.getMessageStream(currentUser.id, widget.user.id),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active &&
                snapshot.data != null) {
              List<types.Message> newMessages = snapshot.data!
                  .map(
                    (messageVo) => types.TextMessage(
                      id: messageVo.id ?? "",
                      text: messageVo.text ?? "",
                      author: types.User(
                          id: messageVo.senderId ?? "",
                          firstName: messageVo.senderName),
                      createdAt: int.parse(messageVo.id ?? ""),
                    ),
                  )
                  .toList();

              /// SORT WITH TIME
              newMessages.sort((b, a) => a.id.compareTo(b.id));
              return Chat(
                scrollPhysics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                // timeFormat: DateFormat('yyyy-MM-dd hh:mm a'),
                // dateFormat: DateFormat('yyyy-MM-dd hh:mm a'),
                theme: const DefaultChatTheme(
                  primaryColor: kPrimaryColor,
                ),
                showUserNames: true,
                onAttachmentPressed: _handleImageSelection,
                messages: newMessages,
                onSendPressed: _handleSendPressed,
                user: currentMessageSender,
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                (snapshot.data?.isEmpty ?? false)) {
              return const Center(
                child: Text(
                  "No active chats. Start chatting now",
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
