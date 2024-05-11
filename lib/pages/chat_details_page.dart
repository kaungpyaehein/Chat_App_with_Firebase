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
              useTopSafeAreaInset: true,
              theme: const DefaultChatTheme(
                primaryColor: kPrimaryColor,
              ),
              showUserNames: true,
              // isAttachmentUploading: messages.isNotEmpty,
              onAttachmentPressed: bloc.handleImageSelection,
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
