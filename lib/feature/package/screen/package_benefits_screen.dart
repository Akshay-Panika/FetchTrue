import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';

class PackageBenefitsScreen extends StatelessWidget {
  const PackageBenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: "Benefits", showBackButton: true,),
      body: SafeArea(child: Column(
        children: [

        ],
      )),
    );
  }
}
