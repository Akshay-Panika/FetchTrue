import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/package/screen/package_benefits_screen.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/widget/gift_package_widget.dart';
import '../bloc/package_bloc.dart';
import '../bloc/package_state.dart';
import '../model/package_model.dart';
import '../repository/package_buy_repository.dart';

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

    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Package', showBackButton: true,),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: CustomAppBar(title: 'Package', showBackButton: true),

      body:BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is UserInitial || userState is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          else if (userState is UserLoaded) {
            return BlocBuilder<PackageBloc, PackageState>(
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
                                  PaymentCard(package: package, user: userState.user),
                                if (selectedPlan == 'sgp')
                                  CustomContainer(height: 300,),
                                if (selectedPlan == 'pgp')
                                  CustomContainer(height: 300,)
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
            );
          }

          else if (userState is UserError){
            print('Error : ${userState.massage}');
          }

          return SizedBox.shrink();

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

        GiftPackageWidget()
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

class PaymentCard extends StatefulWidget {
  final PackageModel package;
  final UserModel user;
  const PaymentCard({super.key, required this.package, required this.user});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final user = widget.user;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if(user.packageActive != true)
            Text('Unlock premium features and grow your team',style: textStyle14(context,color: CustomColor.descriptionColor),),
          15.height,

          if(user.packageActive != true)
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
                                    Center(child: CustomAmountText(amount: '${formatPrice(package.price)}', isLineThrough: true)),
                                  ],
                                ),
                                Center(child: CustomAmountText(amount: '${formatPrice(package.discountedPrice)}', color: CustomColor.appColor)),
                              ],
                            ),
                          ],
                        ),
                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Franchise Deposite'),
                            CustomAmountText(amount: '${formatPrice(package.deposit)}', color: CustomColor.appColor)
                          ],
                        ),
                        Divider(),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Growth Total'),
                            CustomAmountText(amount: '${formatPrice(package.grandtotal)}', color: CustomColor.appColor)
                          ],
                        ),
                        Divider(),

                        if(user.remainingAmount!=0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Remaining Amount'),
                              CustomAmountText(amount: '${formatPrice(user.remainingAmount!)}', color: CustomColor.appColor)
                            ],
                          ),
                      ],
                    ),),

                  // CustomContainer(
                  //   width: double.infinity,
                  //   margin: EdgeInsets.zero,
                  //   color: Color(0xffF2F7FF),
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         children: [
                  //           Expanded(child: Container()),
                  //           Expanded(flex: 2,
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.end,
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               children: [
                  //                 Row(
                  //                   crossAxisAlignment: CrossAxisAlignment.end,
                  //                   mainAxisAlignment: MainAxisAlignment.end,
                  //                   children: [
                  //                     Text('We Assure You up to', style: textStyle14(context),),
                  //                     Text(' 5X Return', style: textStyle14(context, color: CustomColor.appColor),),
                  //                   ],
                  //                 ),
                  //                 5.height,
                  //
                  //                 Text('If you earn less than 5 Lakh in 3 year, we ‘ll refund up to 5X your initial amount', textAlign: TextAlign.right,)
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Text('Safe, secure, and assured returns on your investment.')
                  //     ],
                  //   ),
                  // ),
                  // 10.height,

                  if(user.remainingAmount == 0)
                    CustomContainer(
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                      color: CustomColor.appColor,
                      child: Text('Activate Now', style: textStyle16(context, color: CustomColor.whiteColor),),
                      onTap: () {
                        showActivateBottomSheet(context, package, user);
                      },

                    ),

                  if(user.remainingAmount != 0)
                    CustomContainer(
                      color: CustomColor.appColor,
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                      onTap: isLoading
                          ? null
                          : () async {
                        setState(() => isLoading = true);

                        DateTime now = DateTime.now();
                        String formattedDate = DateFormat("ddMMyyyy_HHmmss").format(now);


                        final isSuccess =
                        await packageBuyPaymentRepository(
                          context: context,
                          orderId: 'package_${formattedDate}',
                          customerId: '${user.id}',
                          customerName: '${user.fullName}',
                          customerPhone: '${user.mobileNumber}',
                          customerEmail: '${user.email}',
                          amount: user.remainingAmount!,
                        );

                        setState(() => isLoading = false);

                        if (isSuccess) {
                          // Payment successful → Refresh User
                          context.read<UserBloc>().add(GetUserById(user.id));
                          // if (context.mounted) {Navigator.pop(context);}
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : Text(
                        'Pay Now',
                        style: textStyle16(context,
                            color: CustomColor.whiteColor),
                      ),
                    ),
                ],
              ),
            ),

          if(user.packageActive == true)
            CustomContainer(
              margin: EdgeInsets.zero,
              color: CustomColor.whiteColor,
              child: Column(
                children: [
                  Text('Fetch True Growth Partner Package', style: textStyle16(context, color: CustomColor.appColor),),
                  10.height,
                  Column(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Extra Benefits', style: textStyle14(context),),
                          Text('You’ve received ₹5,000 as your fixed monthly earning bonus for purchasing the package.')
                        ],
                      )
                    ],
                  ),

                  CustomContainer(
                    color: Color(0xffF2F7FF),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 30, backgroundColor: CustomColor.whiteColor,child: Icon(Icons.image),),
                        10.height,
                        Text('Your package is active', style: textStyle16(context),),
                        Text('Congratulations! Your investment package has been successfully activated.', textAlign: TextAlign.center,)
                      ],
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}




void showActivateBottomSheet(BuildContext context, PackageModel package, UserModel user) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: CustomColor.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      String selectedOption = "full"; // default value
      bool isLoading = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                15.height,
                Text('Amount: ₹ ${package.grandtotal}',
                    style: textStyle16(context)),
                15.height,
                Text(
                  'Select Payment Option',
                  style: textStyle14(context,
                      fontWeight: FontWeight.w400,
                      color: CustomColor.descriptionColor),
                ),

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
                              const Text('Full Payment'),
                              CustomAmountText(amount: '${formatPrice(package.grandtotal)}'),
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
                              const Text('Half Payment'),
                              CustomAmountText(amount: '${formatPrice(package.grandtotal / 2)}'),
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
                        child: Center(
                            child: Text(
                              'Cancel',
                              style: textStyle14(context,
                                  color: CustomColor.redColor),
                            )),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),

                    // ✅ Pay Now Button with Loader
                    Expanded(
                      child: CustomContainer(
                        color: CustomColor.appColor,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        onTap: isLoading
                            ? null
                            : () async {
                          setState(() => isLoading = true);

                          debugPrint("Selected Option: $selectedOption");

                          DateTime now = DateTime.now();
                          String formattedDate = DateFormat("ddMMyyyy_HHmmss").format(now);


                          final isSuccess =
                          await packageBuyPaymentRepository(
                            context: context,
                            orderId: 'package_${formattedDate}',
                            customerId: '${user.id}',
                            customerName: '${user.fullName}',
                            customerPhone: '${user.mobileNumber}',
                            customerEmail: '${user.email}',
                            // amount: selectedOption == "full" ? package.grandtotal : package.grandtotal / 2,
                            amount: selectedOption == "full"
                                ? package.grandtotal.round()
                                : (package.grandtotal / 2).round(),
                          );

                          setState(() => isLoading = false);

                          if (isSuccess) {
                            // Payment successful → Refresh User
                            context.read<UserBloc>().add(GetUserById(user.id));
                            if (context.mounted) {Navigator.pop(context);}
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            'Pay Now',
                            style: textStyle14(context,
                                color: CustomColor.whiteColor),
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
