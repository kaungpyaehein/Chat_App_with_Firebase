import 'dart:typed_data';
import 'package:chat_app/data/models/chat_app_model.dart';
import 'package:chat_app/utils/utils_functions.dart';
import 'package:chat_app/widgets/qr_scanner_overlay.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../utils/strings.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        kTextQRScanner,
        true,
      ),

      /// QR SCANNER VIEW
      body: const QRScannerView(),
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
          ChatAppModel model = ChatAppModel();
          final currentUser = model.getUserDataFromDatabase();

          model
              .exchangeContactsUsingUid(
                  currentUser!.id!, barcodes.first.rawValue ?? "")
              .then((value) {

          });
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(barcodes.first.rawValue ?? ""),
                content: Image.memory(image),
              );
            },
          );
        }
        debugPrint(capture.toString());
      },
    );
  }
}
