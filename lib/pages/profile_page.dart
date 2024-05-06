import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/pages/qr_scanner_page.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

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
    debugPrint(model.getUserDataFromDatabase()?.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          kTextProfile,
          style: TextStyle(
            color: kDefaultBlackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                model.logOut().then((value) {
                  // context.pushReplacement(const SplashPage());
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
      body: Center(
        child: SizedBox(
          height: 250,
          child: PrettyQrView.data(
            decoration: const PrettyQrDecoration(
              background: Colors.white,
              shape: PrettyQrSmoothSymbol(color: kDefaultBlackColor),
            ),
            data: model.getUserDataFromDatabase()?.id ?? "",
          ),
        ),
      ),
    );
  }
}
