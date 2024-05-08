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
import 'package:intl/intl.dart';

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
    currentMessageSender = types.User(id: currentUser.id ?? "");
    super.initState();
  }

  final List<types.Message> _messages = [];

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    // final textMessage = types.TextMessage(
    //   author: message.text == "KP" ? _user2 : _user,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   id: getRandString(10),
    //   text: message.text,
    // );
    firebaseApi.sendMessage(
        MessageVO(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: message.text,
            file: "",
            senderName: "KP",
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

      _addMessage(message);
    }
  }

  final FirebaseApi firebaseApi = FirebaseApiImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(widget.user.name, true),
      body: StreamBuilder<List<MessageVO>>(
          stream: firebaseApi.getMessageStream(currentUser.id, widget.user.id),
          builder: (context, snapshot) {
            print(snapshot.data.toString());
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.active &&
                snapshot.data != null) {
              print(snapshot.data?.length ?? "");
              List<types.Message> newMessages = snapshot.data!
                  .map((messageVo) => types.TextMessage(
                      id: messageVo.id ?? "",
                      text: messageVo.text ?? "",
                      author: types.User(id: messageVo.senderId ?? ""),
                      createdAt: int.parse(messageVo.id ?? "")))
                  .toList();
              newMessages.sort((b, a) => a.id.compareTo(b.id));
              return Chat(
                timeFormat: DateFormat('yyyy-MM-dd hh:mm a'),
                dateFormat: DateFormat('yyyy-MM-dd hh:mm a'),
                theme: const DefaultChatTheme(
                  primaryColor: kPrimaryColor,
                ),
                onAttachmentPressed: _handleImageSelection,
                messages: newMessages,
                onSendPressed: _handleSendPressed,
                user: currentMessageSender,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
