import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusinessIdeaScreen extends StatelessWidget {
  const BusinessIdeaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Business Idea', showBackButton: true, showSearchIcon: true,),

      body: SafeArea(child: Column(
        children: [

        ],
      )),
    );
  }
}
