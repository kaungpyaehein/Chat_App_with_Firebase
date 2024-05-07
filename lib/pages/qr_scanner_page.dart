import 'dart:typed_data';
import 'package:chat_app/bloc/user_info_bloc.dart';
import 'package:chat_app/data/vos/user_vo.dart';
import 'package:chat_app/pages/main_page.dart';
import 'package:chat_app/utils/route/route_extensions.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:chat_app/widgets/qr_scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../utils/colors.dart';
import '../utils/strings.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserInfoBloc(),
      child: Scaffold(
        appBar: buildDefaultAppBar(
          kTextQRScanner,
          true,
        ),

        /// QR SCANNER VIEW
        body: const QRScannerView(),
      ),
    );
  }
}

/// QR SCANNER VIEW
class QRScannerView extends StatelessWidget {
  const QRScannerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserInfoBloc, UserVO?>(
      selector: (context, bloc) => bloc.currentUser,
      builder: (context, value, child) {
        final bloc = context.read<UserInfoBloc>();
        return MobileScanner(
          /// QR SCANNER OVERLAY
          overlay: QRScannerOverlay(
            overlayColour: Colors.black12.withOpacity(0.3),
          ),
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
            returnImage: true,
          ),
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            final Uint8List? image = capture.image;
            for (final barcode in barcodes) {
              debugPrint("Barcode found ! ${barcode.rawValue}");
            }
            if (image != null) {
              final currentUser = bloc.currentUser;

              bloc
                  .exchangeContactsUsingUids(
                      currentUser!.id, barcodes.first.rawValue ?? "")
                  .then(
                (_) {
                  Fluttertoast.showToast(
                      msg: "Successfully added new contact.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: kActiveNowBubbleColor,
                      fontSize: 16.0);
                },
              ).catchError((error) {
                Fluttertoast.showToast(
                    msg: "Failed to add new contact! Please try again.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              });
              Future.delayed(const Duration(milliseconds: 700)).then((_) {
                context.push(const MainPage(
                  selectedIndex: 0,
                ));
              });
            }
          },
        );
      },
    );
  }
}
