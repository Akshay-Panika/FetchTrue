import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_container.dart';

class IDCardScreen extends StatefulWidget {
  const IDCardScreen({super.key});

  @override
  State<IDCardScreen> createState() => _IDCardScreenState();
}

class _IDCardScreenState extends State<IDCardScreen> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _captureAndSaveCard() async {
    if (await Permission.storage.request().isGranted) {
      try {
        RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final directory = await getExternalStorageDirectory();
        String path = '${directory!.path}/id_card_${DateTime.now().millisecondsSinceEpoch}.png';
        File imgFile = File(path);
        await imgFile.writeAsBytes(pngBytes);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("ID Card saved at:\n$path")),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error saving ID Card")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ID Card Screen'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          /// ✅ ID Card View wrapped in RepaintBoundary
          RepaintBoundary(
            key: _globalKey,
            child: CustomContainer(
              backgroundColor: CustomColor.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(CustomImage.nullImage),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Id: 12345', style: textStyle16(context)),
                        Text('Name: Akshay', style: textStyle16(context)),
                        Text('Phone: 9999999999', style: textStyle16(context)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// ✅ Download Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              label: 'Download ID Card',
              onPressed: () {
                _captureAndSaveCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}
