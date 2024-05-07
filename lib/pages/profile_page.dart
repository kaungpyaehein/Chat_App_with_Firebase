import 'package:chat_app/bloc/user_info_bloc.dart';
import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/pages/qr_scanner_page.dart';
import 'package:chat_app/pages/splash_page.dart';
import 'package:chat_app/utils/dimensions.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ChatAppModel model = ChatAppModel();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInfoBloc(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  model.logOut().then((value) {
                    context.pushReplacement(const SplashPage());
                  });
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            HapticFeedback.mediumImpact();
            context.push(const QRScannerPage());
          },
          backgroundColor: kPrimaryColor,
          child: const Icon(
            CupertinoIcons.qrcode_viewfinder,
            color: Colors.white,
          ),
        ),

        /// QR VIEW
        body: Selector<UserInfoBloc, UserVO?>(
          selector: (context, bloc) => bloc.currentUser,
          builder: (context, currentUser, child) {
            if (currentUser != null) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Profile View
                    ProfileView(
                      user: currentUser,
                    ),
                    const Gap(kMarginMedium2),

                    /// Name and Email View
                    NameAndEmailView(user: currentUser),

                    const Gap(kMarginXXLarge),

                    /// QR CODE View
                    QRView(user: currentUser),
                  ],
                ),
              );
            } else {
              return const Center(
                child: Text("Invalid User Info"),
              );
            }
          },
        ),
      ),
    );
  }
}

class NameAndEmailView extends StatelessWidget {
  const NameAndEmailView({
    super.key,
    required this.user,
  });

  final UserVO user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(
              color: kDefaultBlackColor,
              fontSize: kTextRegular2X,
              fontWeight: FontWeight.w700),
        ),
        const Gap(kMarginMedium2),
        Text(
          user.email,
          style: const TextStyle(
              color: kDefaultBlackColor,
              fontSize: kTextRegular2X,
              fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({
    super.key,
    required this.user,
  });
  final UserVO user;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration:
          const BoxDecoration(color: kPrimaryColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          user.getInitialLetters(),
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: kTextRegular3X),
        ),
      ),
    );
  }
}

class QRView extends StatelessWidget {
  const QRView({
    super.key,
    required this.user,
  });

  final UserVO user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PrettyQrView.data(
        decoration: const PrettyQrDecoration(
          background: Colors.white,
          shape: PrettyQrSmoothSymbol(color: kDefaultBlackColor),
        ),
        data: user.id,
      ),
    );
  }
}
