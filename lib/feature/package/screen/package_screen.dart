import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/feature/package/screen/package_benefits_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../model/package_model.dart';
import '../repository/package_buy_repository.dart';
import '../repository/package_service.dart';
import '../widget/show_payment_bottom_widget.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> with SingleTickerProviderStateMixin {
  int _isSelectedTap = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  final List<String> _packages = ['GP', 'SGP', 'PGP'];

  late Future<List<PackageModel>> futurePackages;
  List<PackageModel> _packageData = [];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    futurePackages = PackageService.fetchPackages();
    _tabController = TabController(length: _packages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: const CustomAppBar(title: 'Packages', showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: CustomColor.appColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: CustomColor.appColor,
              onTap: (index) {
                setState(() {
                  _isSelectedTap = index;
                });
                _carouselController.animateToPage(index);
              },
              tabs: _packages.map((pkgName) => Tab(text: pkgName)).toList(),
            ),
            20.height,

            FutureBuilder<List<PackageModel>>(
              future: futurePackages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 250.0),
                    child: Center(
                      child: CircularProgressIndicator(color: CustomColor.appColor),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No packages found"));
                }

                _packageData = snapshot.data!;
                final PackageModel pkg = _packageData[0];

                return Expanded(
                  child: ListView(
                    children: [
                      Center(
                        child: CarouselSlider.builder(
                          itemCount: _packages.length,
                          carouselController: _carouselController,
                          itemBuilder: (context, index, realIndex) {
                            final descKey = _packages[index].toLowerCase();
                            final htmlDesc = pkg.description[descKey] ?? "<p>No description available</p>";

                            // ✅ apka original custom card
                            return _buildPackageCard(context, dimensions, pkg, htmlDesc);
                          },
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            viewportFraction: 0.80,
                            autoPlay: true,
                            initialPage: _isSelectedTap,
                            height: dimensions.screenHeight * 0.5,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _isSelectedTap = index;
                                _tabController.animateTo(index); // ✅ Tab auto update
                              });
                            },
                          ),
                        ),
                      ),

                      10.height,
                      _buildAssuranceSection(context,pkg),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/// Package card
Widget _buildPackageCard(BuildContext context, Dimensions dimensions,PackageModel pkg, String htmlDesc) {
  return CustomContainer(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    backgroundColor: CustomColor.whiteColor,
    border: true,
    borderColor: CustomColor.appColor,
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                backgroundColor: CustomColor.whiteColor,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageBenefitsScreen(htmlDesc:htmlDesc,),)),
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

/// DefineText
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

/// Assurance Section
Widget _buildAssuranceSection(BuildContext context,PackageModel pkg) {
  bool _isBuy = false;
  return CustomContainer(
    border: true,
    borderColor: CustomColor.appColor,
    backgroundColor: CustomColor.whiteColor,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset('assets/package/packageBuyImg.png',)),
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
                ],
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Franchise Fees'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${pkg.discount}%', style: textStyle14(context, color: CustomColor.greenColor),),10.width,
                    CustomAmountText(amount: '${pkg.price}', fontSize: 14,fontWeight: FontWeight.w500, isLineThrough: true, color: CustomColor.descriptionColor),
                  ],
                ),
                CustomAmountText(amount: '${pkg.discountedPrice}', fontSize: 14,fontWeight: FontWeight.w500,color: CustomColor.appColor),
              ],
            ),
          ],
        ),
        Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Franchise Deposit'),
            CustomAmountText(amount: '${pkg.deposit}', fontSize: 14,fontWeight: FontWeight.w500,color: CustomColor.appColor),
          ],
        ),
        Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Growth Total'),
            CustomAmountText(amount: '${pkg.grandtotal}', fontSize: 14,fontWeight: FontWeight.w500,color: CustomColor.appColor),
          ],
        ),
        Divider(),
        10.height,

        GestureDetector(
          onTap: () {
            double price = double.tryParse(pkg.grandtotal.toString()) ?? 0;
            showPaymentBottomSheet(context, price);
          },
          child: CustomContainer(
            backgroundColor: CustomColor.appColor,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
            child: Text(
              'Buy Now',
              style: textStyle14(context, color: CustomColor.whiteColor),
            ),
          ),
        )

      ],
    ),
  );
}

void showPaymentBottomSheet(BuildContext context, double grandTotal) {
  // final userSession = Provider.of<UserSession>(context);
  final userSession = Provider.of<UserSession>(context, listen: false);
  bool _isLoading = false;
  bool isFullPayment = true;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: false,
    backgroundColor: WidgetStateColor.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return CustomContainer(
            backgroundColor: CustomColor.whiteColor,
            padding: EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    20.height,

                    Text('Total Amount', style: textStyle16(context, color: CustomColor.appColor),),
                    CustomAmountText(amount: grandTotal.toStringAsFixed(2),fontSize: 18,fontWeight: FontWeight.w500),
                    20.height,

                    Text('Select Payment Option', style: textStyle14(context, color: CustomColor.descriptionColor),),
                    10.height,
                    CustomContainer(
                      border: true,
                      margin: EdgeInsets.zero,
                      backgroundColor: CustomColor.whiteColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Full Payment Option
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<bool>(
                                value: true,
                                activeColor: CustomColor.appColor,
                                groupValue: isFullPayment,
                                onChanged: (value) {
                                  setState(() {
                                    isFullPayment = value!;
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Full payment', style: textStyle14(context,color: CustomColor.descriptionColor),),
                                  CustomAmountText(amount: grandTotal.toStringAsFixed(2),fontSize: 16,fontWeight: FontWeight.w500),
                                ],
                              ),
                            ],
                          ),

                          /// Half Payment Option
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<bool>(
                                value: false,
                                activeColor: CustomColor.appColor,
                                groupValue: isFullPayment,
                                onChanged: (value) {
                                  setState(() {
                                    isFullPayment = value!;
                                  });
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Half payment', style: textStyle14(context,color: CustomColor.descriptionColor),),
                                  CustomAmountText(amount: (grandTotal / 2).toStringAsFixed(2),fontSize: 16,fontWeight: FontWeight.w500),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    20.height,


                    Text('Descriptions_', style: textStyle12(context, color: CustomColor.descriptionColor),),
                    50.height,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel', style: textStyle16(context,color: Colors.red),),
                        ),
                        const SizedBox(width: 30),
                        CustomContainer(
                          backgroundColor: CustomColor.appColor,
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 25,vertical: 10),
                          child: _isLoading ? CircularProgressIndicator(color: CustomColor.whiteColor,):

                          Text('Pay Now', style: textStyle16(context, color: CustomColor.whiteColor),),

                          onTap: () {
                            Navigator.pop(context);
                            initiatePayment(
                              context: context,
                              amount: isFullPayment ? grandTotal : grandTotal / 2,
                              orderId: "package_12345",
                              customerId: userSession.userId!,
                              customerName: userSession.name!,
                              customerEmail: userSession.email!,
                              customerPhone: userSession.phone!,
                            );
                          },
                        ),
                      ],
                    ),
                    50.height,
                  ],
                ),

                Positioned(
                    right: 0,top: 0,
                    child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.close)))
              ],
            ),
          );
        },
      );
    },
  );
}
