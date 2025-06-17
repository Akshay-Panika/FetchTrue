import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/custom_appbar.dart';

class PartnerReviewScreen extends StatelessWidget {
  const PartnerReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Partner Review', showBackButton: true, showFavoriteIcon: true,),

      body: Column(
        children: [

        ],
      ),
    );
  }
}
