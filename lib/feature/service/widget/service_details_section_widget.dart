import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/service/screen/service_review_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:url_launcher/url_launcher.dart';
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

        /// Image price section
        Stack(
          children: [
            CustomContainer(
              border: true,
              borderColor: CustomColor.greyColor,
              color: Colors.white,
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
                          10.width,
                          
                          CustomAmountText(
                            amount: '${(data.discountedPrice ?? 0).toInt()}',
                            // amount: data.discountedPrice.toString(),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),

                          10.width,

                          if(data.discount != null)
                          Text('${data.discount} %', style: textStyle14(context, color: CustomColor.greenColor),),
                        ],
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ServiceReviewWidget(serviceId: data.id,),));
                          },
                          child: Text(
                            '⭐ ${data.averageRating} (${data.totalReviews} ${'Reviews'})',
                            style: TextStyle(fontSize: 12, color:CustomColor.blackColor ),
                          )),
                    ],
                  ),

                  if(data.includeGst == true)
                  Text('GST Included In Price (Provider Pays GST)', style: textStyle12(context,color: CustomColor.descriptionColor, fontWeight: FontWeight.w400)),

                  10.height,
                  if (data.keyValues.isNotEmpty)
                    ...data.keyValues.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${entry.key} :', style: textStyle12(context, color: CustomColor.descriptionColor)),
                          5.width,
                          Expanded(
                            child: Text(
                              entry.value,
                              style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )),

                ],
              ),
            ),
            Positioned(
                top: 0,right: 10,
                child:  CustomFavoriteButton(),)
          ],
        ),

        /// List
        _buildServiceCard(services: services),

         if(services.first.serviceDetails.extraSections.isNotEmpty)
          ListView.builder(
            itemCount: services.first.serviceDetails.extraSections.length,
            shrinkWrap: true,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var data = services.first.serviceDetails.extraSections[index];
              return CustomContainer(
                border: true,
                color: CustomColor.whiteColor,
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: textStyle14(context),),
                    Text(data.description.toString(), style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                  ],
                ),
              );
            },)
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
    _Section('Why Choose Fetch Ture', null, whyChoose: index.whyChoose),
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
        color: Colors.white,
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
                "table": Style(
                  width: Width.auto(),
                  border: Border.all(color: CustomColor.strokeColor, width: 0.3),
                ),
                "td": Style(
                  padding: HtmlPaddings.all(5),
                  border: Border.all(color: CustomColor.strokeColor, width: 0.3),
                ),
                "th": Style(
                  backgroundColor: Colors.grey.shade200,
                  padding: HtmlPaddings.all(5),
                  border: Border.all(color: CustomColor.strokeColor, width: 0.3),
                ),
              },
              extensions: [TableHtmlExtension()],
              onLinkTap: (url, attributes, element) async{
                if (url != null){
                  await launchUrl(Uri.parse(url));
                }
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
      color: Colors.white,
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
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Why Choose Fetch Ture', style: textStyle14(context)),
        15.height,
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: list.length,
            itemBuilder: (context, index) {
              final data = list[index];

              if ((data.title == null || data.title!.isEmpty) &&
                  (data.image == null || data.image!.isEmpty)) {
                return SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.title != null && data.title!.isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Left: Title + Description
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.title.toString(), style: textStyle12(context)),
                                SizedBox(height: 5),
                                Text(
                                  data.description.toString(),
                                  style: textStyle12(
                                    context,
                                    color: CustomColor.descriptionColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          /// Right: Small Image
                          if (data.image != null && data.image!.isNotEmpty)
                            Expanded(
                              child: CustomContainer(
                                height: 100,
                                networkImg: data.image.toString(),
                                margin: EdgeInsets.zero,
                              ),
                            ),
                        ],
                      ),


                    if ((data.title == null || data.title!.isEmpty) &&
                        data.image != null && data.image!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(data.image.toString()),
                      ),
                  ],
                ),
              );
            }

        )
      ],
    ),
  );
}

Widget _buildFAQs(BuildContext context, List<Faq> list) {
  return CustomContainer(
    border: true,
    borderColor: CustomColor.greyColor,
    color: Colors.white,
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

            final data = list[index];

            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,    // disables ripple
                highlightColor: Colors.transparent, // disables highlight
              ),
              child: ExpansionTile(
                backgroundColor: CustomColor.whiteColor,
                iconColor: CustomColor.appColor,
                shape: InputBorder.none,
                childrenPadding: EdgeInsets.zero,
                collapsedShape: InputBorder.none,
                tilePadding: EdgeInsets.zero,
                minTileHeight: 0,
                title: Text(data.question, style: textStyle14(context)),
                children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Expanded(child: Text(data.answer))
                   ],
                 )
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

