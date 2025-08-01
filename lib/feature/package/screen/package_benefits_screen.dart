import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/widgets/custom_appbar.dart';

class PackageBenefitsScreen extends StatelessWidget {
  final String htmlDesc;
  const PackageBenefitsScreen({super.key, required this.htmlDesc});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: "Benefits", showBackButton: true,),
      body: SafeArea(child:
      SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Html(data: htmlDesc))),
    );
  }
}
