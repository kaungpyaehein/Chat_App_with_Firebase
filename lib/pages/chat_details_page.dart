import 'package:chat_app/bloc/chat_details_bloc.dart';
import 'package:chat_app/data/models/chat_app_model.dart';
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
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider(
      create: (context) => ChatDetailsBloc(widget.user.id),
      child: Scaffold(
        appBar: buildDefaultAppBar(widget.user.name, true),
        body: Selector<ChatDetailsBloc, List<types.Message>>(
          selector: (context, bloc) => bloc.messages,
          builder: (context, messages, child) {
            final ChatDetailsBloc bloc = context.read<ChatDetailsBloc>();
            return Chat(
              scrollPhysics: const BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              theme: const DefaultChatTheme(
                primaryColor: kPrimaryColor,
              ),
              showUserNames: true,
              onAttachmentPressed: _handleImageSelection,
              messages: messages,
              onSendPressed: bloc.handleSendPressed,
              user: bloc.currentMessageSender,
            );
          },
        ),
      ),
    );
  }
}
