import 'package:chat_app/bloc/user_info_bloc.dart';
import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/network/api/firebase_api.dart';
import 'package:chat_app/network/api/firebase_api_impl.dart';
import 'package:chat_app/pages/chat_details_page.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../utils/utils_functions.dart';

class ContactListPage extends StatelessWidget {
  const ContactListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInfoBloc(),
      child: Scaffold(
        appBar: buildDefaultAppBar(kTextContactList, false),

        /// CONTACT LIST VIEW
        body: const ContactListView(),
      ),
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
  @override
  Widget build(BuildContext context) {
    return Selector<UserInfoBloc, UserVO?>(
      selector: (context, bloc) => bloc.currentUser,
      builder: (context, currentUser, widget) {
        if (currentUser != null && currentUser.contacts!.isNotEmpty) {
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
            separatorBuilder: (context, index) {
              return const Divider(
                color: kDividerColor,
              );
            },
            itemCount: currentUser.contacts!.length,
            itemBuilder: (context, index) {
              return ContactListItemView(
                user: currentUser.contacts![index],
              );
            },
          );
        } else if (currentUser!.contacts!.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(
          child: Text(
            "Error Fetching Contacts or Empty Contact List.",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}

/// Contact List Item View
class ContactListItemView extends StatelessWidget {
  const ContactListItemView({
    super.key,
    required this.user,
  });

  final UserVO user;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push(ChatDetailsPage(
          user: user,
        ));
      },
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        height: 56,
        width: 56,
        child: Container(
          decoration: BoxDecoration(
              color: kAvatarBackgroundColor,
              borderRadius: BorderRadius.circular(kMarginMedium3)),
          child: Center(
            child: Text(
              user.getInitialLetters(),
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: kTextRegular2X),
            ),
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        user.email,
        style: const TextStyle(color: kHintTextColor),
      ),
    );
  }
}
