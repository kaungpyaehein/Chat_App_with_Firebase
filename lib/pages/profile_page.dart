import 'package:chat_app/pages/qr_scanner_page.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/strings.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../utils/colors.dart';
import '../utils/images.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(kTextProfile, false),
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
            data: "this is qr data",
          ),
        ),
      ),
    );
  }
}