import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../utils/utils_functions.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(kTextContactList, false),

      /// CONTACT LIST VIEW
      body: const ContactListView(),
    );
  }
}

class ContactListView extends StatefulWidget {
  const ContactListView({
    super.key,
  });

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView> {
  FirebaseApi firebaseApi = FirebaseApiImpl();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserVO>>(
        stream: firebaseApi.getContactsStream("4pV0ovJtGJQirmUkStzDgmOrO112"),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            debugPrint(snapshot.data.toString());
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
              separatorBuilder: (context, index) {
                return const Divider(
                  color: kDividerColor,
                );
              },
              itemCount: 5,
              itemBuilder: (context, index) {
                return const ContactListItemView();
              },
            );
          }
          return const SizedBox.shrink();
        });
  }
}

class ContactListItemView extends StatelessWidget {
  const ContactListItemView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 56,
        width: 56,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kAvatarBackgroundColor,
                  borderRadius: BorderRadius.circular(kMarginMedium3)),
              child: const Center(
                child: Text(
                  "KP",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: kTextRegular2X),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: Container(
                  height: kMargin12,
                  width: kMargin12,
                  decoration: const BoxDecoration(
                      color: kActiveNowBubbleColor, shape: BoxShape.circle),
                ),
              ),
            )
          ],
        ),
      ),
      title: const Text(
        "Kaung Pyae Hein",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: const Text(
        "Online",
        style: TextStyle(color: kHintTextColor),
      ),
    );
  }
}
