import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/package/screen/package_benefits_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path/path.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../bloc/package_bloc.dart';
import '../bloc/package_state.dart';
import '../model/package_model.dart';

class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  String selectedPlan = 'gp';

  final Map<String, Map<String, dynamic>> packages = {
    'gp': {
      'packageName': 'Growth Partner (GP)',
      'price': '₹30,000 - ₹50,000/Month',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Team Building Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Marketing Support',
          'dec':'Earn 5% to 15% revenue share.',
        },
      ]
    },
    'sgp': {
      'packageName': 'Super Growth Partner (SGP)',
      'price': '₹50,000 - ₹70,000/Month',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'dec':'Earn up to 15% revenue share on all successful leads you generate.',
        },
        {
          'headline':'Team Building Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Team Revenue Income',
          'dec':'empty'
        },
        {
          'headline':'Marketing Support',
          'dec':'Earn 5% to 15% revenue share.',
        },
      ]
    },
    'pgp': {
      'packageName': 'Premium Growth Partner (SGP)',
      'price': '₹70,000 - ₹1,00,000/Month ',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'dec':'Earn up to 15% revenue share on all successful leads you generate.',
        },
        {
          'headline':'Team Building Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Team Revenue Income',
          'dec':'Earn 5% to 15% revenue share.',
        },
        {
          'headline':'Marketing Support',
          'dec':'Earn 5% to 15% revenue share.',
        },
      ]
    },
  };


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(title: 'Package', showBackButton: true),

      body: BlocBuilder<PackageBloc, PackageState>(
        builder: (context, state) {
          if (state is PackageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is PackageLoaded) {
            final PackageModel package = state.packages.first;
            return DefaultTabController(
              length: 3,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    /// Tabs
                    SliverAppBar(
                      pinned: false,
                      floating: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      toolbarHeight: 40,
                      flexibleSpace: Container(
                        color: Colors.white,
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          indicatorColor: CustomColor.appColor,
                          labelColor: Colors.black,
                          onTap: (index) {
                            setState(() {
                              if (index == 0) selectedPlan = 'gp';
                              if (index == 1) selectedPlan = 'sgp';
                              if (index == 2) selectedPlan = 'pgp';
                            });
                          },
                          tabs: const [
                            Tab(text: "GP"),
                            Tab(text: "SGP"),
                            Tab(text: "PGP"),
                          ],
                        ),
                      ),
                    ),

                    /// Body
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildEnhancedMainCard(context,packages[selectedPlan]!,package, selectedPlan),

                             if (selectedPlan == 'gp')
                            _buildPaymentCard(context, package),
                            if (selectedPlan == 'sgp')
                            CustomContainer(
                              height: 300,
                            ),
                          if (selectedPlan == 'pgp')
                            CustomContainer(
                              height: 300,
                            )
                        ],
                      ),
                    ),

                    SliverToBoxAdapter(child: 50.height),
                  ],
                ),
              ),
            );
          }
          else if (state is PackageError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Main Card with Pricing
Widget _buildEnhancedMainCard(BuildContext context ,Map<String, dynamic> packages, PackageModel package, String planKey) {
  return Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.grey.shade200,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 32,
                backgroundColor: CustomColor.appColor,
                child: CircleAvatar(radius: 31,backgroundColor: CustomColor.whiteColor,
                child: Text(planKey.toUpperCase()),),
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${packages['packageName']}',style: textStyle16(context, color: CustomColor.appColor),),
                  10.height,
                  Text('${packages['price']}', style: textStyle12(context, color: CustomColor.greenColor),),
                  // Text('${packages['monthFixEarning']}', style: textStyle14(context, color: CustomColor.greenColor),),
                  Text('Monthly Fix Earning: ₹ ${package.monthlyEarnings}/Month', style: textStyle14(context, color: CustomColor.greenColor),),
                ],
              )
            ],
          ),
        ),
        20.height,

        _buildEnhancedFeaturesSection(context),
        10.height,

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to promoted GP to SGP?', style: textStyle18(context),),
            Text('Recruit 10 Growth Partner to become a Super Growth Partner (SGP)', style: textStyle14(context,color: CustomColor.descriptionColor),),
          ],
        ),
        10.height,

        CustomContainer(
          border: true,
          color: WidgetStateColor.transparent,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 15,
            children: [
              _labelText(context,'REVENUE',
                ["Earn 5% to 15% revenue share.",],
              ),
              _labelText(context,'TEAM BUILDING INCOME',
                [
                  "Earn ₹5,000 for every GP you onboard",
                  "Get ₹3,000 when your onboarded GP brings another."
                ],
              ),

              _labelText(context,'MARKETING SUPPORT',
                [
                  "Support within 3-6 hours.",
                  "Full support system.",
                  "Expert help, anytime you need it."
                ],
              ),

              InkWell(
                child: Row(
                  children: [
                    Icon(Icons.arrow_forward_ios, size: 16,color: CustomColor.appColor,),10.width,
                    Text('Benefit', style: textStyle14(context, color: CustomColor.appColor),)
                  ],
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageBenefitsScreen(package: package, planKey: planKey,),)),
              ),
            ],
          ),
        ),
        10.height,
                
        Text('Welcome Gift'),
        Wrap(
          children: List.generate(7, (index) =>
            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              child: Text('Gift', style: textStyle12(context),),),),
        ),
      ],
    ),
  );
}

/// What’s Includes
Widget _buildEnhancedFeaturesSection(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  CustomColor.appColor,
                ],
              ),
            ),
          ),
        ),
        16.width,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Icon(Icons.star, color: CustomColor.appColor, size: 16),
            6.width,
            Text('What’s Includes', style: textStyle14(context, color: CustomColor.appColor),),
          ],
        ),
        16.width,
        Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CustomColor.appColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildPaymentCard(BuildContext context, PackageModel package){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Unlock premium features and grow your team',style: textStyle14(context,color: CustomColor.descriptionColor),),
        15.height,

        CustomContainer(
          color: CustomColor.whiteColor,
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(padding: EdgeInsetsGeometry.all(10),
              child: Column(
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
                            children: [
                              Text('${package.discount} %', style: textStyle14(context, color: CustomColor.greenColor),),10.width,
                              Center(child: CustomAmountText(amount: '${package.price}', isLineThrough: true)),
                            ],
                          ),
                          Center(child: CustomAmountText(amount: '${package.discountedPrice}', color: CustomColor.appColor)),
                        ],
                      ),
                    ],
                  ),
                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Franchise Deposite'),
                      CustomAmountText(amount: '${package.deposit}', color: CustomColor.appColor)
                    ],
                  ),
                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Growth Total'),
                      CustomAmountText(amount: '${package.grandtotal}', color: CustomColor.appColor)
                    ],
                  ),
                  Divider(),
                ],
              ),),

              CustomContainer(
               width: double.infinity,
                margin: EdgeInsets.zero,
                color: Color(0xffF2F7FF),
                child: Column(
                  children: [
                   Row(
                     children: [
                       Expanded(child: Container()),
                       Expanded(flex: 2,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Row(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Text('We Assure You up to', style: textStyle14(context),),
                                 Text(' 5X Return', style: textStyle14(context, color: CustomColor.appColor),),
                               ],
                             ),
                             5.height,

                             Text('If you earn less than 5 Lakh in 3 year, we ‘ll refund up to 5X your initial amount', textAlign: TextAlign.right,)
                           ],
                         ),
                       ),
                     ],
                   ),
                   Text('Safe, secure, and assured returns on your investment.')
                  ],
                ),
              ),
              10.height,

              CustomContainer(
                padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                color: CustomColor.appColor,
                child: Text('Activate Now', style: textStyle16(context, color: CustomColor.whiteColor),),
                onTap: () {
                  showActivateBottomSheet(context);
                },

              )
            ],
          ),
        ),
      ],
    ),
  );
}

void showActivateBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: CustomColor.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      String selectedOption = "full"; // default value

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Text('Amount: ₹1,00,000', style: textStyle16(context)),
                15.height,
                Text('Select Payment Option', style: textStyle14(context,fontWeight: FontWeight.w400,color: CustomColor.descriptionColor)),

                CustomContainer(
                  border: true,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Full Payment Option
                      Row(
                        children: [
                          Radio<String>(
                            value: "full",
                            activeColor: CustomColor.appColor,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Full Payment'),
                              CustomAmountText(amount: '100000'),
                            ],
                          ),
                        ],
                      ),

                      // Half Payment Option
                      Row(
                        children: [
                          Radio<String>(
                            value: "half",
                            activeColor: CustomColor.appColor,
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value!;
                              });
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Half Payment'),
                              CustomAmountText(amount: '50000'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

               15.height,
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Center(child: Text('Cancel', style: textStyle14(context, color: CustomColor.redColor),)),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    Expanded(
                      child: CustomContainer(
                        color: CustomColor.appColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        onTap: () {
                          Navigator.pop(context);
                          debugPrint("Selected Option: $selectedOption");
                        },
                        child: Center(
                          child: Text('Pay Now', style: textStyle14(context, color: CustomColor.whiteColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                50.height,
              ],
            ),
          );
        },
      );
    },
  );
}


Widget _labelText(
    BuildContext context,
    String headline,
    List<String> descriptions, // multiple descriptions
    ) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        children: [
          const Icon(Icons.check_circle_outline_outlined, size: 16),
          const SizedBox(width: 10),
          Text(headline, style: textStyle12(context)),
        ],
      ),
      const SizedBox(height: 4),

      /// multiple descriptions
      Padding(
        padding: const EdgeInsets.only(left:5,top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: descriptions.map((des) {
            return Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                   Padding(
                     padding: const EdgeInsets.only(top: 5.0,right: 5),
                     child: Icon(Icons.circle, size: 8, color: CustomColor.iconColor,),
                   ),

                  Expanded(
                    child: Text(
                      des,
                      style: textStyle12(
                        context,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ],
  );
}
