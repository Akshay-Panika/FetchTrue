import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/widgets/custom_appbar.dart';

class PackageBenefitsScreen extends StatelessWidget {
  final String htmlDesc;
  const PackageBenefitsScreen({super.key, required this.htmlDesc});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(title: "Benefits", showBackButton: true,),
      body: SafeArea(child:
      CustomContainer(
        backgroundColor: Colors.white,
        child: Html(data: htmlDesc),
      )),
    );
  }
}
