import 'package:carousel_slider/carousel_slider.dart';
import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/feature/package/screen/package_benefits_screen.dart';
import 'package:fetchtrue/feature/profile/bloc/user/user_event.dart';
import 'package:fetchtrue/feature/profile/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/model/user_model.dart';
import '../../profile/repository/user_service.dart';
import '../model/package_model.dart';
import '../repository/package_buy_repository.dart';
import '../repository/package_service.dart';

class PackageScreen extends StatefulWidget {
  final String userId;
  const PackageScreen({super.key, required this.userId});

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

  Future<void> _refreshData() async {
    setState(() {
      futurePackages = PackageService.fetchPackages();
    });
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

            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshData,
                child: FutureBuilder<List<PackageModel>>(
                  future: futurePackages,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: CustomColor.appColor),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No packages found"));
                    }

                    final pkg = snapshot.data![0];

                    return ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Center(
                          child: CarouselSlider.builder(
                            itemCount: _packages.length,
                            carouselController: _carouselController,
                            itemBuilder: (context, index, realIndex) {
                              final descKey = _packages[index].toLowerCase();
                              final htmlDesc = pkg.description[descKey] ?? "<p>No description available</p>";

                              switch (index) {
                                case 0: // GP
                                  return _buildPackageCard(
                                    context: context,
                                    dimensions: dimensions,
                                    pkg: pkg,
                                    htmlDesc: htmlDesc,
                                    title: 'Growth Partner (GP)',
                                    earning: '₹30,000 - ₹50,000/Month',
                                    promotionDesc: 'Recruit 10 Growth Partner to become a Super Growth Partner (SGP)',
                                    sections: [
                                      {'REVENUE': ['Earn 5% to 15% revenue share.']},
                                      {'TEAM BUILDING INCOME': ['Earn 5% to 15% revenue share.', 'Get ₹3,000 when your onboarded GP brings another.']},
                                      {'MARKETING SUPPORT': ['Support within 3-6 hours.', 'Full support system.', 'Expert help, anytime you need it.']},
                                    ],
                                  );
                                case 1: // SGP
                                  return _buildPackageCard(
                                    context: context,
                                    dimensions: dimensions,
                                    pkg: pkg,
                                    htmlDesc: htmlDesc,
                                    title: 'Super Growth Partner (SGP)',
                                    earning: '₹50,000 - ₹70,000/Month',
                                    promotionDesc: 'Support 3 Super Growth Partners (SGPs) in your team to qualify as a Premium Growth Partner (PGP).',
                                    sections: [
                                      {'REVENUE': ['Earn up to 15% revenue share on all successful leads you generate.']},
                                      {'TEAM BUILDING INCOME': ['Earn ₹5,000 for every GP you onboard.', 'Get ₹3,000 when your onboarded GP brings another.']},
                                      {'MARKETING SUPPORT': ['Support within 3-6 hours.', 'Full support system.', 'Expert help, anytime you need it.']},
                                    ],
                                  );
                                case 2: // PGP
                                  return _buildPackageCard(
                                    context: context,
                                    dimensions: dimensions,
                                    pkg: pkg,
                                    htmlDesc: htmlDesc,
                                    title: 'Premium Growth Partner (PGP)',
                                    earning: '₹70,000 - ₹1,00,000/Month',
                                    promotionDesc: 'You are a Premium Growth Partner (PGP) and eligible for unlimited earnings.',
                                    sections: [
                                      {'REVENUE': ['Earn up to 15% revenue share on all successful leads you generate.']},
                                      {'TEAM BUILDING INCOME': ['Earn ₹5,000 for every GP you onboard.', 'Get ₹3,000 when your onboarded GP brings another.']},
                                      {'TEAM REVENUE INCOME': ['Extra earn 5% to 8% for direct team revenue.', 'Extra earn 3% to 7% for indirect team revenue.']},
                                      {'MARKETING SUPPORT': ['Support within 3-6 hours.', 'Full support system.', 'Expert help, anytime you need it.']},
                                    ],
                                  );
                                default:
                                  return SizedBox.shrink();
                              }
                            },
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              viewportFraction: 0.85,
                              autoPlay: false,
                              initialPage: _isSelectedTap,
                              height: dimensions.screenHeight * 0.7,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _isSelectedTap = index;
                                  _tabController.animateTo(index);
                                });
                              },
                            ),
                          ),
                        ),
                        10.height,
                        BlocProvider(
                          create: (_) => UserBloc(UserRepository())..add(GetUserById(widget.userId)),
                          child: BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              if (state is UserLoading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (state is UserLoaded) {
                                final user = state.user;
                                return _buildAssuranceSection(context, pkg, user);
                              } else if (state is UserError) {
                                return Center(child: Text('Error: ${state.massage}'));
                              }
                              return const Center(child: Text("No Data"));
                            },
                          ),
                        ),
                        50.height
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Reusable package card method
  Widget _buildPackageCard({
    required BuildContext context,
    required Dimensions dimensions,
    required PackageModel pkg,
    required String htmlDesc,
    required String title,
    required String earning,
    required String promotionDesc,
    required List<Map<String, List<String>>> sections,
  }) {
    return CustomContainer(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      color: CustomColor.whiteColor,
      border: true,
      borderColor: CustomColor.appColor,
      child: Column(
        children: [
          // Header
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
                  backgroundImage: AssetImage(CustomLogo.fetchTrueLogo),
                  backgroundColor: CustomColor.whiteColor,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Fetch True', style: textStyle16(context, color: CustomColor.appColor)),
                    Text(title, style: textStyle12(context, color: CustomColor.appColor)),
                    Text('Assure Earning', style: textStyle12(context, color: CustomColor.greenColor, fontWeight: FontWeight.bold)),
                    Text(earning, style: textStyle12(context, color: CustomColor.greenColor)),
                  ],
                )
              ],
            ),
          ),

          // Body
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('How to promoted?', style: textStyle14(context)),
                      Text(promotionDesc, style: textStyle14(context, color: CustomColor.descriptionColor)),
                      5.height,
                      Divider(height: 0),
                      ...sections.map((section) => _buildDefineText(
                        context,
                        headline: section.keys.first,
                        define: section.values.first.map((e) => _buildDotText(e)).toList(),
                      )),
                    ],
                  ),
                ),
                CustomContainer(
                  border: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  color: CustomColor.whiteColor,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageBenefitsScreen(htmlDesc: htmlDesc))),
                  child: Text('Know Benefits', style: textStyle14(context, color: CustomColor.appColor)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// Assurance Section
  Widget _buildAssuranceSection(BuildContext context,PackageModel pkg, UserModel user) {
    return
      CustomContainer(
        border: true,
        borderColor: CustomColor.appColor,
        color: CustomColor.whiteColor,
        child: Column(
          children: [
            Row(
              children: [
                Text('Monthly Earnings :', style: textStyle14(context),),
                5.width,
                CustomAmountText(amount: '${pkg.monthlyEarnings}', fontSize: 14,fontWeight: FontWeight.w500)
              ],
            ),
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

            /// Package
            if(user.packageActive != true)
            Column(
              children: [
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

                _buildAmountRow(label: 'Franchise Deposit', amount: '${pkg.deposit}'),
                Divider(),

                _buildAmountRow(label: 'Grand Total', amount: '${pkg.grandtotal}'),
              ],
            ),

            if(user.packageAmountPaid !=0 && user.remainingAmount == 0)
            /// Full Amount
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CustomContainer(
                  margin: EdgeInsets.zero,
                  color: CustomColor.appColor.withOpacity(0.1),
                  child: Column(
                    children: [
                       Icon(Icons.verified_user, size: 50,color: CustomColor.greenColor,),
                       Text('Your Package Is Active', style: textStyle16(context, color: CustomColor.appColor),),
                       10.height,
                       Text('Congratulations! Your investment package has been successfully activated.', style: textStyle12(context, color: CustomColor.descriptionColor),textAlign: TextAlign.center,),
                      // Center(child: _buildAmountRow(label: 'Paid Amount', amount: user.packageAmountPaid.toString())),
                    ],
                  ),
                ),
              ),

            if(user.packageAmountPaid ==0)
              Divider(),

            if(user.remainingAmount !=0)
            /// Half Amount
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: CustomContainer(
                  margin: EdgeInsets.zero,
                  color: CustomColor.appColor.withOpacity(0.1),
                  child: Column(
                    children: [
                      Center(child: _buildAmountRow(label: 'Paid Amount', amount: user.packageAmountPaid.toString())),
                      Divider(),
                      Center(child:  _buildAmountRow(label: 'Remaining Amount', amount: user.remainingAmount.toString())),
                      Divider(),

                      /// Pay now button
                      RemainingPaymentButton(grandTotal: user.remainingAmount!.toDouble(),onPaymentSuccess: _refreshData,),
                    ],
                  ),
                ),
              ),

            /// Pay now button
            if(user.packageAmountPaid ==0)
              CustomContainer(
                color: CustomColor.appColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                child: Text('Buy Now', style: textStyle14(context, color: CustomColor.whiteColor),),
                onTap: () {
                  double price = double.tryParse(pkg.grandtotal.toString()) ?? 0;
                  _showPaymentBottomSheet(context, price, _refreshData);
                },
              ),

          ],
        ),
      );
  }
}

/// DefineText
Widget _buildDefineText(BuildContext context,
    {String? headline, List<Widget>? define}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(headline ?? '', style: textStyle14(context, color: CustomColor.appColor)),
        Column(
          children: define!,
        )
      ],
    ),
  );
}

Widget _buildDotText(String? label){
  return  Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(top: 4.0, right: 5),
        child: Icon(Icons.circle, size: 8, color: CustomColor.iconColor),
      ),
      Expanded(child: Text(label!)),
    ],
  );
}

Widget _buildAmountRow({String? label, String? amount}){
  return  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label!),
      CustomAmountText(amount: amount!, fontSize: 14,fontWeight: FontWeight.w500,color: CustomColor.appColor),
    ],
  );
}


void _showPaymentBottomSheet(BuildContext context, double grandTotal, VoidCallback? onPaymentSuccess) {
  final userSession = Provider.of<UserSession>(context, listen: false);

  bool isFullPayment = true;
  bool _isLoading = false;


  final now = DateTime.now();
  final formattedOrderId =
      "${now.day.toString().padLeft(2, '0')}/"
      "${now.month.toString().padLeft(2, '0')}/"
      "${now.year.toString().substring(2)}/_"
      "${now.hour.toString().padLeft(2, '0')}:"
      "${now.minute.toString().padLeft(2, '0')}:"
      "${now.second.toString().padLeft(2, '0')}";

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
            color: CustomColor.whiteColor,
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
                      color: CustomColor.whiteColor,
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
                          color: CustomColor.appColor,
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 25, vertical: 10),
                          onTap: _isLoading
                              ? null
                              : () async {
                            setState(() {
                              _isLoading = true;
                            });

                            final result = await initiatePackagePayment(
                              context: context,
                              amount: isFullPayment ? grandTotal : grandTotal / 2,
                              orderId: 'package_$formattedOrderId',
                              customerId: userSession.userId!,
                              customerName: 'Akshay',
                              customerEmail: 'Akshay@gmail.com',
                              customerPhone: '8989207770',
                            );

                            setState(() {
                              _isLoading = false;
                            });

                            if (result == true) {
                              onPaymentSuccess?.call();
                              Navigator.pop(context, true);
                            }
                          },

                          child: _isLoading
                              ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,),)
                              : Text('Pay Now', style: textStyle16(context, color: CustomColor.whiteColor)),
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


class RemainingPaymentButton extends StatefulWidget {
  final double grandTotal;
  final VoidCallback? onPaymentSuccess; // ✅ callback for success

  const RemainingPaymentButton({super.key, required this.grandTotal, this.onPaymentSuccess});

  @override
  State<RemainingPaymentButton> createState() => _RemainingPaymentButtonState();
}

class _RemainingPaymentButtonState extends State<RemainingPaymentButton> {
  bool _isLoading = false;
  bool isFullPayment = true;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context, listen: false);

    final now = DateTime.now();
    final formattedOrderId =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year.toString().substring(2)}/_"
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";

    return CustomContainer(
      color: CustomColor.appColor,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 8),
      onTap: _isLoading
          ? null
          : () async {
        setState(() {
          _isLoading = true;
        });

        final result = await initiatePackagePayment(
          context: context,
          amount: isFullPayment
              ? widget.grandTotal
              : widget.grandTotal / 2,
          orderId: 'package_$formattedOrderId',
          customerId: userSession.userId!,
          customerName: 'Akshay',
          customerEmail: 'Akshay@gmail.com',
          customerPhone: '8989207770',
        );

        setState(() {
          _isLoading = false;
        });

        if (result == true) {
          print("Payment Success");
          widget.onPaymentSuccess?.call();
        }
      },
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 2,
        ),
      )
          : Text('Pay Now',
          style: textStyle14(context, color: CustomColor.whiteColor)),
    );
  }
}
