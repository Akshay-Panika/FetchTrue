import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/feature/package/screen/package_benefits_screen.dart';
import 'package:fetchtrue/feature/profile/model/user_model.dart';
import 'package:fetchtrue/feature/team_build/screen/team_build_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../five_x/bloc/five_x/FiveXBloc.dart';
import '../../five_x/bloc/five_x/FiveXState.dart';
import '../../five_x/model/FiveXModel.dart';
import '../../five_x/screen/five_x_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../widget/gift_package_widget.dart';
import '../bloc/package/package_bloc.dart';
import '../bloc/package/package_state.dart';
import '../model/package_model.dart';
import '../repository/package_buy_repository.dart';
import '../widget/gp_progress_widget.dart';
import '../widget/sgp_progress_widget.dart';

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
          'des':[
            'Earn 5% to 15% revenue share.'
          ],
        },
        {
          'headline':'Team Building Income',
          'des':[
            'Earn ₹5,000 for every GP you onboard',
            'Get ₹3,000 when your onboarded GP brings another.'
          ]
        },
        {
          'headline':'Marketing Support',
          'des':[
            'Support within 3-6 hours.',
            'Full support system.',
            'Expert help, anytime you need it.'
          ],
        },
      ],
      'includes': {
        'title': 'How to promoted GP to SGP?',
        'des': 'Recruit 10 Growth Partner to become a Super Growth Partner (SGP)'
      },
    },
    'sgp': {
      'packageName': 'Super Growth Partner (SGP)',
      'price': '₹50,000 - ₹70,000/Month',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'des':['Earn up to 15% revenue share on all successful leads you generate.']
        },
        {
          'headline':'Team Building Income',
          'des':[
            'Earn ₹5,000 for every GP you onboard',
            'Get ₹3,000 when your onboarded GP brings another.'
          ]
        },
        {
          'headline':'Team Revenue Income',
          'des':['Extra earn 5% to 8% for team revenue.']
        },
        {
          'headline':'Marketing Support',
          'des':[
            'Support within 3-6 hours.',
            'Full support system.',
            'Expert help, anytime you need it.'
          ],
        },
      ],
      'includes': {
        'title':'How to promoted SGP to PGP?',
        'des':'Support 3 (SGPs) in your team to qualify as a Premium Growth Partner (PGP).'
      },
    },
    'pgp': {
      'packageName': 'Premium Growth Partner (PGP)',
      'price': '₹70,000 - ₹1,00,000/Month ',
      'monthFixEarning':'Monthly Fix Earning: ₹4,000/Month',
      'des':[
        {
          'headline':'Revenue',
          'des':['Earn up to 15% revenue share on all successful leads you generate.']
        },
        {
          'headline':'Team Building Income',
          'des':[
            'Earn ₹5,000 for every GP you onboard',
            'Get ₹3,000 when your onboarded GP brings another.'
          ]
        },
        {
          'headline':'Team Revenue Income',
          'des':[
            'Extra earn 5% to 8% for direct team revenue.',
            'Extra earn 3% to 7% for indirect team revenue.'
          ]
        },
        {
          'headline':'Marketing Support',
          'des':[
            'Support within 3-6 hours.',
            'Full support system.',
            'Expert help, anytime you need it.'
          ],
        },
      ],
      'includes': {
        'title':'How to promoted PGP?',
        'des': 'You are a Premium Growth Partner (PGP) and eligible for unlimited earnings.'
      }
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

                  return  BlocBuilder<FiveXBloc, FiveXState>(
                    builder: (context, state) {
                      if (state is FiveXLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is FiveXLoaded) {

                        final fiveX = state.data.first;
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
                                      _buildEnhancedMainCard(context,
                                          userState.user,
                                          packages[selectedPlan]!,package, selectedPlan),

                                      if (selectedPlan == 'gp')
                                        PaymentCard(package: package, user: userState.user, fiveX: fiveX,),
                                      if (selectedPlan == 'sgp')
                                        Column(
                                          children: [
                                            Center(child: Image.asset('assets/image/pgp_img.png',height: 400,)),
                                            CustomContainer(
                                              width: 200,
                                              color: CustomColor.appColor,
                                              child: Center(child: Text('Claim Now', style: textStyle14(context, color: CustomColor.whiteColor),)),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor: CustomColor.whiteColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      title: const Text("🎉 Claim Reward"),
                                                      content: const Text(
                                                        "Your claim feature will be available soon.\nStay tuned!",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text("Close"),
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: CustomColor.appColor,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            // Future claim logic yahan add karna
                                                          },
                                                          child:  Text("Claim Now", style: textStyle12(context, color: CustomColor.whiteColor),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      if (selectedPlan == 'pgp')
                                        Column(
                                          children: [
                                            Center(child: Image.asset('assets/image/sgp_img.png',height: 400,)),
                                            CustomContainer(
                                              width: 200,
                                              color: CustomColor.appColor,
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      backgroundColor: CustomColor.whiteColor,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      title: const Text("🎉 Claim Reward"),
                                                      content: const Text(
                                                        "Your claim feature will be available soon.\nStay tuned!",
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          child: const Text("Close"),
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: CustomColor.appColor,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            // Future claim logic yahan add karna
                                                          },
                                                          child:  Text("Claim Now", style: textStyle12(context, color: CustomColor.whiteColor),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Center(child: Text('Claim Now', style: textStyle14(context, color: CustomColor.whiteColor),)),
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                ),

                                SliverToBoxAdapter(child: 50.height),
                              ],
                            ),
                          ),
                        );

                      } else if (state is FiveXError) {
                        return Center(child: Text(state.message));
                      }
                      return const Center(child: Text("Press button to fetch data"));
                    },
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
Widget _buildEnhancedMainCard(BuildContext context , UserModel user,Map<String, dynamic> packages, PackageModel package, String planKey) {

  return Container(
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
        CustomContainer(
          color: Color(0xffEDF4FF),
          margin: EdgeInsets.zero,
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.packageStatus =='nonGP'?'Non-GP':user.packageStatus.toString(), style: textStyle16(context),),
                  Text('Current Level', style: textStyle12(context, color: CustomColor.appColor),)
                ],
              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${packages['packageName']}',style: textStyle16(context, color: CustomColor.appColor),),
                  Text('Assured Earnings', style: textStyle14(context, color: CustomColor.greenColor),),
                  Text('${packages['price']}', style: textStyle12(context, color: CustomColor.greenColor),),
                  CustomContainer(
                    margin: EdgeInsets.zero,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                      child: Text('Monthly Fix Earning: ₹ ${package.monthlyEarnings}/Month', style: textStyle12(context, color: CustomColor.blackColor),)),
                ],
              )
            ],
          ),
        ),
        10.height,

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Text(packages['includes']['title'].toString(), style: textStyle12(context, color: CustomColor.blackColor),),
                Text(packages['includes']['des'].toString(), style: textStyle12(context, color: Colors.grey.shade600,),),
            ],
          ),
        ),

        if(user.packageActive == true && planKey == 'gp')
          GpProgressWidget(
            userId: user.id,
            targetCount: 10,
          ),

        if(user.packageActive == true && planKey == 'sgp')
          SgpProgressWidget(
            userId: user.id,
            targetCount: 3,
          ),
        20.height,


        _buildEnhancedFeaturesSection(context),

        Column(
          children: List.generate(
            packages['des'].length,
                (index) {
              final feature = packages['des'][index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _labelText(
                  context,
                  feature['headline'],
                  List<String>.from(feature['des']),
                ),
              );
            },
          ),
        ),

        10.height,

        InkWell(
          child: Row(
            children: [
              Icon(Icons.arrow_forward_ios, size: 16,color: CustomColor.appColor,),
              10.width,
              Text('Explore Benefits', style: textStyle12(context, color: CustomColor.appColor),)
            ],
          ),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PackageBenefitsScreen(package: package, planKey: planKey,),)),
        ),

        20.height,


        if (planKey == 'gp')
        GiftPackageWidget(),

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
            Text('What’s Includes', style: textStyle12(context, color: CustomColor.appColor),),
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
  final FiveXModel fiveX;
  const PaymentCard({super.key, required this.package, required this.user, required this.fiveX});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final user = widget.user;
    return  CustomContainer(
      color: CustomColor.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(user.packageActive != true)
            Column(
              children: [
                Center(child: Text('Unlock premium features and grow your team', style: textStyle12(context, color: CustomColor.descriptionColor),)),
                Divider()
              ],
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Up to 5X Returns Guarantee!!!', style: textStyle12(context, color: CustomColor.appColor),),
                        3.height,

                        Text('Refund up to 5X if earning are less than ₹ ${widget.fiveX.fixearning} in 3 years', textAlign: TextAlign.start,
                          style: textStyle12(context, color: CustomColor.descriptionColor,fontWeight: FontWeight.w400),),
                        10.height,

                        _buildIconText(context,
                            Icons.security,
                            'Secure'
                        ),
                        _buildIconText(context,
                            Icons.safety_check_rounded,
                            'Safe Investment'
                        ),
                        _buildIconText(context,
                            Icons.currency_rupee,
                            'Guaranteed Refund'
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Image.asset('assets/image/package_active_img.png')),
                ],
              ),
              10.height,

              Text('Your Extra Benefits', style: textStyle12(context, color: CustomColor.appColor),),
              Text('You’ve received ₹ ${package.monthlyEarnings} as your fixed monthly earning bonus for purchasing the package.', style: textStyle12(context, color:CustomColor.descriptionColor,fontWeight: FontWeight.w400),)
            ],
          ),
          10.height,

          Column(
            children: [
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
                        Text('Franchise Deposit (Refundable)'),
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


                  ],
                ),
              10.height,

              if(user.packageAmountPaid == 0 )
                CustomContainer(
                  padding: EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                  color: CustomColor.appColor,
                  child: Text('Activate Now', style: textStyle14(context, color: CustomColor.whiteColor),),
                  onTap: () {
                    showActivateBottomSheet(context, package, user);
                  },

                ),

              if(user.remainingAmount != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paid Amount: ₹ ${user.packageAmountPaid}'),
                        Text('Remaining Amount: ₹ ${user.remainingAmount}'),
                      ],
                    ),
                    CustomContainer(
                      color: CustomColor.appColor,
                      margin: EdgeInsets.zero,
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
                        style: textStyle14(context,
                            color: CustomColor.whiteColor),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          if(user.packageActive == true)
            CustomContainer(
              margin: EdgeInsets.zero,
              color: Color(0xffF2F7FF),
              child: Column(
                children: [
                  Image.asset('assets/image/active_package_img.png',height: 100,),
                  Text('Your package is active', style: textStyle16(context),),
                  Text('Congratulations! Your investment package has been successfully activated.', textAlign: TextAlign.center,)
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) =>  FiveXScreen()));
              },
            )
        ],
      ),
    );
  }
}


Widget _buildIconText(BuildContext context, IconData icon, String label){
  return Row(
    children: [
     Icon(icon, size: 16, color: CustomColor.iconColor,),
     5.width,
     Text(label, style: textStyle12(context,fontWeight: FontWeight.w400, color: CustomColor.descriptionColor),)
    ],
  );
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
                        padding: const EdgeInsets.symmetric(vertical: 6),
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
          Icon(Icons.verified_outlined, size: 16, color: CustomColor.greenColor,),
          const SizedBox(width: 10),
          Text(headline.toUpperCase(), style: textStyle12(context, fontWeight: FontWeight.w400)),
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
                     child: Icon(Icons.circle, size: 8, color: Colors.grey[500],),
                   ),

                  Expanded(
                    child: Text(
                      des,
                      style: textStyle12(
                        context,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600
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

