import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/widgets/custom_ratting_and_reviews.dart';
import 'package:bizbooster2x/feature/service/widget/service_review_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_favorite_button.dart';
import '../model/service_model.dart';

class ServiceDetailsSectionWidget extends StatelessWidget {
 final List<ServiceModel> services;
  const ServiceDetailsSectionWidget({super.key, required this.services,});

  @override
  Widget build(BuildContext context) {

    final data = services.first;
    return Column(
      children: [
        Stack(
          children: [
            CustomContainer(
              border: true,
              borderColor: CustomColor.greyColor,
              backgroundColor: Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(data.serviceName, style: textStyle16(context,)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [

                          CustomAmountText(
                              amount: data.price.toString(),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              isLineThrough: true
                          ),
                          SizedBox(width: 10),
                          CustomAmountText(
                            amount: data.discountedPrice.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReviewWidget(),));
                          },
                          child: CustomRattingAndReviews()),
                    ],
                  ),

                  10.height,
                  if (data.keyValues != null && data.keyValues!.isNotEmpty)
                    ...data.keyValues!.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('${entry.key} :', style: textStyle12(context)),
                          5.width,
                          Text(entry.value, style: textStyle12(context)),
                        ],
                      ),
                    ))

                ],
              ),
            ),
            Positioned(
                top: 0,right: 10,
                child: CustomFavoriteButton())
          ],
        ),
        _buildServiceCard(services: services),
      ],
    );
  }
}


Widget _buildServiceCard({required List<ServiceModel> services}) {
  final index = services.first.serviceDetails;

  final sections = [
    _Section('Benefits', index.benefits),
    _Section('Overview', index.overview),
    // _Section('Highlight', index.highlight as String?),
    _Section('Highlight', null, highlightImages: index.highlight),
    _Section('Document', index.document),
    _Section('Why Choose BizBooster', null, whyChoose: index.whyChoose),
    _Section('How it work', index.howItWorks),
    _Section('T&C', index.termsAndConditions),
    _Section('FAQs', null, faqs: index.faq),
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: sections.length,
    itemBuilder: (context, index) {
      final section = sections[index];

      if (section.whyChoose != null) return _buildWhyChoose(context, section.whyChoose!);
      if (section.faqs != null)      return _buildFAQs(context, section.faqs!);
      if (section.highlightImages != null )  return _buildHighlight(context,images: section.highlightImages!);
      return CustomContainer(
        border: true,
        borderColor: CustomColor.greyColor,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title, style: textStyle14(context)),

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
  final List<String>? highlightImages;
  final List<WhyChoose>? whyChoose;
  final List<Faq>? faqs;
  _Section(this.title, this.html, {this.highlightImages, this.whyChoose, this.faqs});
}


Widget _buildHighlight(BuildContext context,{required List<String> images,}){
  return CustomContainer(
      border: true,
      borderColor: CustomColor.greyColor,
      backgroundColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Highlight', style: textStyle14(context)),
          15.height,
          ListView.builder(
              itemCount: images.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
              return Image.network(images[index].toString());
              },
          ),
        ],
      ),
  );
}

Widget _buildWhyChoose(BuildContext context, List<WhyChoose> list) {
  return CustomContainer(
    border: true,
    borderColor: CustomColor.greyColor,
    backgroundColor: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why Choose BizBooster', style: textStyle14(context)),
        10.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return
              list.first.title == null ?
              Image.network(list.first.image.toString()):
              Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(list.first.title.toString(), style: textStyle12(context)),
                      5.height,
                      Text(list.first.description.toString(), style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),
                    ],
                  )),
                  Expanded(
                    child: CustomContainer(
                      height: 100,
                      networkImg: list.first.image,
                      margin: EdgeInsets.zero,
                    ),
                  )
                ],
              )
            );
          },)
      ],
    ),
  );
}

Widget _buildFAQs(BuildContext context, List<Faq> list) {
  return CustomContainer(
    border: true,
    borderColor: CustomColor.greyColor,
    backgroundColor: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FAQs', style: textStyle14(context)),
        ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,    // disables ripple
                highlightColor: Colors.transparent, // disables highlight
              ),
              child: ExpansionTile(
                // initiallyExpanded: true,
                backgroundColor: CustomColor.whiteColor,
                iconColor: CustomColor.appColor,
                shape: InputBorder.none,
                childrenPadding: EdgeInsets.zero,
                collapsedShape: InputBorder.none,
                tilePadding: EdgeInsets.zero,
                title: Text(list.first.question, style: textStyle14(context)),
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text(list.first.answer)),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

