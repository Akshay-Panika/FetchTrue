import 'package:flutter/cupertino.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_service_list.dart';

class ProviderServicesListWidget extends StatelessWidget {
  const ProviderServicesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
            color: CustomColor.appColor.withOpacity(0.1),
            child: CustomServiceList(headline: 'Best Service')),
        Container(
            color: CustomColor.blueColor.withOpacity(0.1),
            child: CustomServiceList(headline: 'Popular Service')),
        Container(
            color: CustomColor.greenColor.withOpacity(0.1),
            child: CustomServiceList(headline: 'All Service')),
      ],
    );
  }
}
