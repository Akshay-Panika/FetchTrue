import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PackageScreen extends StatelessWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Package', showBackButton: true,),

      body: SafeArea(child: Column(
        children: [

        ],
      )),
    );
  }
}
