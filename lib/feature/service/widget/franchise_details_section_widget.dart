import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/service_model.dart';

class FranchiseDetailsSectionWidget extends StatelessWidget {
  final List<ServiceModel> services;
   FranchiseDetailsSectionWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        CustomContainer(
          border: true,
          borderColor: CustomColor.greyColor,
          backgroundColor: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          // padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You will earn commission',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.appColor,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Up To',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      10.width,
                      Text('${services.first.franchiseDetails.commission}', style: textStyle22(context, color: CustomColor.greenColor),)
                    ],
                  ),
                ],
              ),
              Container(
                height: 100,width: 150,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(image: AssetImage('assets/package/packageBuyImg.png'), fit: BoxFit.cover)
                ),
              )
            ],
          ),
        ),
        _buildFranchiseCard(services:services),
      ],
    );
  }
}


Widget _buildFranchiseCard({
  required List<ServiceModel> services

}){
  final index = services.first.franchiseDetails;
  final sections = [
    _Section('Overview', index.overview),
    _Section('How It Works', index.howItWorks),
    _Section('T&C', index.termsAndConditions),
  ];
  return  ListView.builder(
    itemCount: sections.length,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      final section = sections[index];
      return CustomContainer(
          border: true,
          borderColor: CustomColor.greyColor,
          backgroundColor: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(section.title,style: textStyle14(context),),

              Html(
                data: section.html ?? '',
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    color: CustomColor.descriptionColor,
                  ),
                },
              ),
            ],
          ),
        );
    },
  );
}

class _Section {
  final String title;
  final String? html;
  final List<WhyChoose>? whyChoose;
  final List<Faq>? faqs;
  _Section(this.title, this.html, {this.whyChoose, this.faqs});
}