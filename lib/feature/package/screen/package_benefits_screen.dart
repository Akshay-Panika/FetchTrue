import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../model/package_model.dart';

class PackageBenefitsScreen extends StatelessWidget {
  final PackageModel package;
  final String planKey;
  const PackageBenefitsScreen({super.key, required this.package, required this.planKey,});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: "Benefits", showBackButton: true,),
      body: SafeArea(child:
      SingleChildScrollView(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
          child: Html(
            data: package.description[planKey] ?? "",
          ),
      )
      ),
    );
  }
}
