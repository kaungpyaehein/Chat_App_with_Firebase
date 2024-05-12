import 'dart:async';
import 'dart:io';
import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/vos/message_vo.dart';
import '../data/vos/user_vo.dart';

class ChatDetailsBloc extends ChangeNotifier {
  late UserVO currentUser;
  ChatAppModel model = ChatAppModel();

  List<MessageVO> allMessages = [];
  FirebaseApi firebaseApi = FirebaseApiImpl();

  StreamSubscription? messagesSubscription;

  String? messageReceiverId;

  ChatDetailsBloc(String receiverId) {
    messageReceiverId = receiverId;
    messagesSubscription =
        model.getMessageStream(receiverId).listen((messageList) {
      if (messageList.isNotEmpty) {
        messageList.sort((b, a) => a.id!.compareTo(b.id!));
        allMessages = messageList;
        notifyListeners();
      }
    });

    currentUser = model.getUserDataFromDatabase()!;
  }

  void handleSendPressed(message) {
    firebaseApi.sendMessage(
      MessageVO(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: message,
          file: "",
          senderName: currentUser.name,
          senderId: currentUser.id,
          type: "text"),
      currentUser.id,
      messageReceiverId ?? "",
    );
  }

  void handleImageSelection() async {
    final XFile? result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      String pickTime = DateTime.now().millisecondsSinceEpoch.toString();

      final File file = File(result.path);
      final storage = FirebaseStorage.instance.ref();
      final chats = storage.child("chats");
      final images = chats.child("images");
      final imageLocation = images.child(pickTime);

      try {
        await imageLocation.putFile(file);
        final imageUrl = await imageLocation.getDownloadURL();
        firebaseApi.sendMessage(
          MessageVO(
              id: pickTime,
              text: "Photo Message",
              file: imageUrl,
              senderName: currentUser.name,
              senderId: currentUser.id,
              type: "image"),
          currentUser.id,
          messageReceiverId ?? "",
        );
      } catch (error) {

      }
    }
  }

  @override
  void dispose() {
    messagesSubscription!.cancel();
    super.dispose();
  }
}

// import 'dart:async';
// import 'dart:io';
// import 'package:chat_app/data/models/chat_app_model.dart';
// import 'package:chat_app/network/api/firebase_api.dart';
// import 'package:chat_app/network/api/firebase_api_impl.dart';
// import 'package:chat_app/persistence/message_dao.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../data/vos/message_vo.dart';
// import '../data/vos/user_vo.dart';
//
// class ChatDetailsBloc extends ChangeNotifier {
//   late types.User currentMessageSender;
//   late UserVO currentUser;
//   MessageDao messageDao = MessageDao();
//   List<types.Message> messages = [];
//   ChatAppModel model = ChatAppModel();
//
//   final TextEditingController messageInputController = TextEditingController();
//   List<MessageVO> allMessages = [];
//
//   FirebaseApi firebaseApi = FirebaseApiImpl();
//
//   StreamSubscription? messagesSubscription;
//
//   String? messageReceiverId;
//
//   ChatDetailsBloc(String receiverId) {
//     messageReceiverId = receiverId;
//     messagesSubscription =
//         model.getMessageStream(receiverId).listen((messageList) {
//           List<types.Message> newMessages = messageList.map(
//                 (messageVo) {
//               if (messageVo.type == "image") {
//                 types.ImageMessage(
//                   name: "Image",
//                   author: types.User(
//                       id: messageVo.senderId ?? "",
//                       firstName: messageVo.senderName),
//                   createdAt: int.parse(messageVo.id ?? ""),
//                   id: messageVo.id ?? "",
//                   // uri: messageVo.file.toString(),
//                   uri: Uri.tryParse(messageVo.file ?? "").toString(),
//                   size: 1024 * 1024,
//                 );
//               }
//               return types.TextMessage(
//                 id: messageVo.id ?? "",
//                 text: messageVo.text ?? "",
//                 author: types.User(
//                     id: messageVo.senderId ?? "", firstName: messageVo.senderName),
//                 createdAt: int.parse(messageVo.id ?? ""),
//               );
//             },
//           ).toList();
//           newMessages.sort((b, a) => a.id.compareTo(b.id));
//           messages = newMessages;
//           notifyListeners();
//         });
//
//     currentUser = model.getUserDataFromDatabase()!;
//     currentMessageSender = types.User(
//       id: currentUser.id,
//       firstName: currentUser.name,
//     );
//   }
//
//   void handleSendPressed(types.PartialText message) {
//     firebaseApi.sendMessage(
//       MessageVO(
//           id: DateTime.now().millisecondsSinceEpoch.toString(),
//           text: message.text,
//           file: "",
//           senderName: currentUser.name,
//           senderId: currentUser.id,
//           type: "text"),
//       currentUser.id,
//       messageReceiverId ?? "",
//     );
//     // _addMessage(textMessage);
//   }
//
//   void handleImageSelection() async {
//     final XFile? result = await ImagePicker().pickImage(
//       imageQuality: 70,
//       maxWidth: 1440,
//       source: ImageSource.gallery,
//     );
//
//     if (result != null) {
//       String pickTime = DateTime.now().millisecondsSinceEpoch.toString();
//
//       final File file = File(result.path);
//       print(file.toString());
//       final storage = FirebaseStorage.instance.ref();
//       final chats = storage.child("chats");
//       final images = chats.child("images");
//       final imageLocation = images.child(pickTime);
//
//       try {
//         await imageLocation.putFile(file);
//
//         final imageUrl = await imageLocation.getDownloadURL();
//
//         print(imageUrl.toString());
//
//         firebaseApi.sendMessage(
//           MessageVO(
//               id: pickTime,
//               text: "",
//               file: imageUrl,
//               senderName: currentUser.name,
//               senderId: currentUser.id,
//               type: "image"),
//           currentUser.id,
//           messageReceiverId ?? "",
//         );
//       } catch (error) {
//         print(error.toString());
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     messagesSubscription!.cancel();
//     super.dispose();
//   }
// }
