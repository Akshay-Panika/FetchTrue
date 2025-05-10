import 'package:bizbooster2x/core/costants/custom_color.dart';
import 'package:bizbooster2x/core/costants/custom_image.dart';
import 'package:bizbooster2x/core/costants/dimension.dart';
import 'package:bizbooster2x/core/costants/text_style.dart';
import 'package:bizbooster2x/core/widgets/custom_amount_text.dart';
import 'package:bizbooster2x/core/widgets/custom_appbar.dart';
import 'package:bizbooster2x/core/widgets/custom_container.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  int _isSelectedTap = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<String> _packages = ['GP', 'SGP', 'PGP'];

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Packages', showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(_packages.length, (index) {
                    return _buildFranchiseTap(
                      context,
                      label: _packages[index],
                      isSelected: _isSelectedTap == index,
                      onTap: () {
                        setState(() => _isSelectedTap = index);
                        _carouselController.animateToPage(index);
                      },
                    );
                  }),
                ),
              ),
              20.height,
              CarouselSlider.builder(
                itemCount: 3,
                carouselController: _carouselController,
                itemBuilder: (context, index, realIndex) {
                  return _buildPackageCard(context, dimensions);
                },
                options: CarouselOptions(
                  height: dimensions.screenHeight * 0.5,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.80,
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (index, reason) {
                    setState(() => _isSelectedTap = index);
                  },
                ),
              ),
              _buildAssuranceSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPackageCard(BuildContext context, Dimensions dimensions) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.2),
        borderRadius: BorderRadius.circular(dimensions.screenHeight * 0.01),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(dimensions.screenWidth * 0.02),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(dimensions.screenHeight * 0.01),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(CustomImage.nullImage),
                  backgroundColor: CustomColor.whiteColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('BizBooster', style: textStyle16(context, color: CustomColor.appColor)),
                    Text('Growth Partner (GB)', style: textStyle12(context, color: CustomColor.appColor)),
                     CustomAmountText(
                      amount: '7,00,000',
                      decoration: false,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Text(
                        'Priority Access: Gain early access to franchise opportunities in all categories',
                        style: textStyle14(context, color: CustomColor.descriptionColor),
                      ),
                      _buildDefineText(
                        context,
                        headline: 'REVENUE',
                        define: 'Earn 5%-15% revenue share.',
                      ),
                      _buildDefineText(
                        context,
                        headline: 'REFERRAL BENEFIT',
                        define: 'Get up to ₹5,000 per team member.',
                      ),
                      _buildDefineText(
                        context,
                        headline: 'MARKETING SUPPORT',
                        define:
                        'Commission: 5% to 15% per successful lead\nOnboarding Bonus: ₹5000 per direct GP, ₹3000 per indirect',
                      ),
                    ],
                  ),
                ),
                CustomContainer(
                  border: true,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  backgroundColor: CustomColor.whiteColor,
                  child: Text(
                    'Know Benefits',
                    style: textStyle14(context, color: CustomColor.appColor),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFranchiseTap(BuildContext context,
      {required String label,
        required bool isSelected,
        VoidCallback? onTap}) {
    Dimensions dimensions = Dimensions(context);
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? CustomColor.appColor.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(dimensions.screenHeight * 0.01),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300, width:  isSelected ? 0.4:0.8,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: textStyle14(context, color: isSelected ? Colors.blue : Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefineText(BuildContext context,
      {String? headline, String? define}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headline ?? '', style: textStyle14(context, color: CustomColor.appColor)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.only(top: 4.0, right: 5),
                child: Icon(Icons.circle, size: 8, color: CustomColor.iconColor),
              ),
              Expanded(
                child: Text(
                  define ?? '',
                  style: textStyle14(context,
                      color: CustomColor.descriptionColor,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssuranceSection(BuildContext context) {
    return CustomContainer(
      border: true,
      backgroundColor: CustomColor.whiteColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Image.asset(CustomImage.nullImage, height: 100)),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'We assure you  ',
                            style: textStyle14(context)),
                        TextSpan(
                          text: '5X Return ',
                          style: textStyle16(context,
                              color: CustomColor.appColor),
                        ),
                      ]),
                    ),
                    10.height,
                    Text(
                      'If you earn less than our assured earnings, we’ll refund up to 5X your initial amount',
                      style: textStyle12(context,
                          color: CustomColor.descriptionColor),
                      textAlign: TextAlign.right,
                    ),
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         CustomAmountText(amount: '7,00,000'),
                        10.width,
                        CustomContainer(
                          backgroundColor: CustomColor.appColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: Text(
                            'Buy Now',
                            style: textStyle14(context,
                                color: CustomColor.whiteColor),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          10.height,
          CustomContainer(
            border: true,
            borderColor: CustomColor.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            child: Text(
              'Check Your Discount Eligibility',
              style: textStyle12(context),
            ),
          ),
        ],
      ),
    );
  }
}
