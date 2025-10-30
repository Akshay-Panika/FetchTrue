// Flutter & Third-party
import 'package:fetchtrue/feature/profile/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Core Constants
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';

// Core Widgets
import 'package:fetchtrue/core/widgets/custom_amount_text.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:fetchtrue/core/widgets/no_user_sign_widget.dart';

// Helpers
import 'package:fetchtrue/helper/Contact_helper.dart';

// Features → Auth
import '../../../core/widgets/custom_snackbar.dart';
import '../../auth/user_notifier/user_notifier.dart';

// Features → Profile
import '../../profile/model/user_model.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';

// Features → Package
import '../model/package_model.dart';
import '../model/package_buy_payment_model.dart';
import '../model/referral_user_model.dart';
import '../repository/package_repository.dart';
import '../repository/package_buy_payment_repository.dart';
import '../repository/referral_repository.dart';
import '../bloc/package/package_bloc.dart';
import '../bloc/package/package_event.dart';
import '../bloc/package/package_state.dart';
import '../bloc/package_payment/package_buy_payment_bloc.dart';
import '../bloc/package_payment/package_buy_payment_event.dart';
import '../bloc/package_payment/package_buy_payment_state.dart';
import '../bloc/referral/referral_bloc.dart';
import '../bloc/referral/referral_event.dart';
import '../bloc/referral/referral_state.dart';
import '../widget/gift_package_widget.dart';
import '../widget/gp_progress_widget.dart';
import '../widget/package_data.dart';
import '../widget/sgp_progress_widget.dart';
import '../screen/package_benefits_screen.dart';
import '../screen/package_payment_webview_screen.dart';

// Features → FiveX
import '../../five_x/model/FiveXModel.dart';
import '../../five_x/repository/fivex_repository.dart';
import '../../five_x/bloc/five_x/fivex_bloc.dart';
import '../../five_x/bloc/five_x/fivex_event.dart';
import '../../five_x/bloc/five_x/fivex_state.dart';
import '../../five_x/screen/five_x_screen.dart';

// Features → Team Build
import '../../team_build/model/my_team_model.dart';
import '../../team_build/repository/my_team_repository.dart';
import '../../team_build/bloc/my_team/my_team_bloc.dart';
import '../../team_build/bloc/my_team/my_team_event.dart';
import '../../team_build/bloc/my_team/my_team_state.dart';


class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  String selectedPlan = 'gp';

  void _reloadAllData(BuildContext context, String userId) {
    context.read<UserBloc>().add(GetUserById(userId));
    context.read<PackageBloc>().add(FetchPackages());
    context.read<FiveXBloc>().add(FetchFiveX());
    context.read<ReferralBloc>().add(LoadReferrals(userId));
    context.read<MyTeamBloc>().add(FetchMyTeam(userId));
  }

  @override
  Widget build(BuildContext context) {

    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Package', showBackButton: true,),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc(UserRepository())..add(GetUserById(userSession.userId!))),
        BlocProvider(create: (_) => PackageBloc(PackageRepository())..add(FetchPackages())),
        BlocProvider(create: (_) => FiveXBloc(FiveXRepository())..add(FetchFiveX())),
        BlocProvider(create: (_) => ReferralBloc(ReferralRepository())..add(LoadReferrals(userSession.userId!))),
        BlocProvider(create: (_) => MyTeamBloc(MyTeamRepository())..add(FetchMyTeam(userSession.userId!))),
        BlocProvider(create: (_) => PackagePaymentBloc(repository: PackageBuyPaymentRepository())),

      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CustomAppBar(title: 'Package', showBackButton: true),

        body: BlocBuilder<UserBloc, UserState>(
            builder: (context, userState) {
              if (userState is UserInitial || userState is UserLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if(userState is UserLoaded){

                return MultiBlocListener(
                  listeners: [
                    BlocListener<PackageBloc, PackageState>(
                      listener: (context, state) {
                        if (state is PackageError) debugPrint('Package Error: ${state.error}');
                      },
                    ),
                    BlocListener<FiveXBloc, FiveXState>(
                      listener: (context, state) {
                        if (state is FiveXError) debugPrint('Five X Error: ${state.message}');
                      },
                    ),
                    BlocListener<ReferralBloc, ReferralState>(
                      listener: (context, state) {
                        if (state is ReferralError) debugPrint('Referral Error: ${state.message}');
                      },
                    ),
                    BlocListener<MyTeamBloc, MyTeamState>(
                      listener: (context, state) {
                        if (state is MyTeamError) debugPrint('Team Error: ${state.message}');
                      },
                    ),
                  ],

                  child:  RefreshIndicator(
                    color: CustomColor.appColor,
                    onRefresh: () async {
                      _reloadAllData(context, userSession.userId!);
                      await Future.delayed(const Duration(seconds: 1));
                    },
                    child: Builder(builder: (context) {
                      final packageState = context.watch<PackageBloc>().state;
                      final fiveXState = context.watch<FiveXBloc>().state;
                      final referralState = context.watch<ReferralBloc>().state;
                      final teamState = context.watch<MyTeamBloc>().state;
                    
                      if (packageState is PackageLoading || fiveXState is FiveXLoading ||
                          referralState is ReferralLoading || teamState is MyTeamLoading) {
                        return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
                      }
                      if(packageState is PackageLoaded && fiveXState is FiveXLoaded && referralState is ReferralLoaded && teamState is MyTeamLoaded) {
                        final package = packageState.packages.first;
                        final fiveX = fiveXState.data.first;
                        final referral = referralState.referrals;
                        final teams = teamState.response;
                    
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
                                          packages[selectedPlan]!,package, selectedPlan, referral, teams),
                    
                                      if (selectedPlan == 'gp')
                                        PaymentCard(package: package, user: userState.user, fiveX: fiveX, onPaymentSuccess: () {
                                          _reloadAllData(context, userSession.userId!);
                                        },),
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
                    
                      }
                    
                      return const SizedBox.shrink();
                    
                    },),
                  ),
                );
              }

              if (userState is UserError) {
                debugPrint('Error: ${userState.massage}');
              }

              return SizedBox.shrink();
          }
        ),
      ),
    );
  }
}

/// Main Card with Pricing
Widget _buildEnhancedMainCard(BuildContext context ,
    UserModel user,Map<String, dynamic> packages,
    PackageModel package, String planKey,
    List<ReferralUser> referral,
     List<MyTeamModel> team,
    ) {

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
              if(team.length == 10)
                Text(packages['includes']['des'].toString(), style: textStyle12(context, color: Colors.grey.shade600,),),
            ],
          ),
        ),

        if(user.packageActive == true && planKey == 'gp')
          GpProgressWidget(
            referral: referral,
            team: team,
          ),

        if(user.packageActive == true && planKey == 'sgp')
          SgpProgressWidget(
            team: team,
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
  final VoidCallback? onPaymentSuccess;

  const PaymentCard({super.key, required this.package, required this.user, required this.fiveX, this.onPaymentSuccess});

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final package = widget.package;

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
                        Text('Franchise Deposit (Refundable)'),
                        CustomAmountText(amount: '${package.deposit}', color: CustomColor.appColor)
                      ],
                    ),
                    Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Growth Total'),
                        CustomAmountText(amount: '${(package.discountedPrice+package.deposit)}', color: CustomColor.appColor)
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
                  child: Text('Active Now', style: textStyle14(context, color: CustomColor.whiteColor),),
                  onTap: () async {
                    final result = await showActivateBottomSheet(context, package, user);
                    if (result == true) {
                      widget.onPaymentSuccess?.call();
                    }
                  },
                ),

              if(user.remainingAmount != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Paid Amount: ₹ ${user.packageAmountPaid}'),
                        Text('Remaining Amount: ₹ ${user.remainingAmount}'),
                      ],
                    ),

                    BlocConsumer<PackagePaymentBloc, PackagePaymentState>(
                      listener: (context, state) async {
                        if (state is PackagePaymentSuccess) {
                          final paymentUrl = state.response.result?.paymentLink ?? "";
                          if (paymentUrl.isNotEmpty) {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PackagePaymentWebViewScreen(paymentUrl: paymentUrl),
                              ),
                            );

                            // ✅ Payment successful → refresh all data
                            if (result == true && context.mounted) {
                              final userSession = Provider.of<UserSession>(context, listen: false);
                              context.read<UserBloc>().add(GetUserById(userSession.userId!));
                              context.read<PackageBloc>().add(FetchPackages());
                              context.read<FiveXBloc>().add(FetchFiveX());
                              context.read<ReferralBloc>().add(LoadReferrals(userSession.userId!));
                              context.read<MyTeamBloc>().add(FetchMyTeam(userSession.userId!));
                            }
                          }
                        } else if (state is PackagePaymentFailure) {
                          showCustomSnackBar(context, "Payment Failed: ${state.error}");
                        }
                      },
                      builder: (context, state) {
                        if (state is PackagePaymentLoading) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return CustomContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                          color: CustomColor.appColor,
                          onTap: () {
                            final orderId = "package_${DateTime.now().millisecondsSinceEpoch}";
                            final model = PackageBuyPaymentModel(
                              subAmount: user.remainingAmount!.round(),
                              isPartialPaymentAllowed: false,
                              description: "Fetch True Payment",
                              orderId: orderId,
                              customer: Customer(
                                customerId: user.id,
                                customerName: user.fullName,
                                customerEmail: user.email,
                                customerPhone: user.mobileNumber,
                              ),
                              udf: Udf(
                                udf1: orderId,
                                udf2: '',
                                udf3: user.id,
                              ),
                            );

                            // ✅ Trigger payment creation event
                            context.read<PackagePaymentBloc>().add(CreatePaymentLinkEvent(model));
                          },
                          child: Text(
                            'Active Now',
                            style: textStyle14(context, color: CustomColor.whiteColor),
                          ),
                        );
                      },
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

Future<bool?> showActivateBottomSheet(
    BuildContext context,
    PackageModel package,
    UserModel user,
    ) async {
  final selectedOptionNotifier = ValueNotifier<String>("full");
  bool? paymentSuccess;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: CustomColor.whiteColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (bottomSheetContext) {
      return BlocConsumer<PackagePaymentBloc, PackagePaymentState>(
        listener: (context, state) async {
          if (state is PackagePaymentSuccess) {
            final paymentUrl = state.response.result?.paymentLink ?? "";
            if (paymentUrl.isNotEmpty) {
              Navigator.of(bottomSheetContext, rootNavigator: true).pop();
              paymentSuccess = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PackagePaymentWebViewScreen(paymentUrl: paymentUrl),
                ),
              );
              if (paymentSuccess == true && context.mounted) {
                final userSession = Provider.of<UserSession>(context, listen: false);
                context.read<UserBloc>().add(GetUserById(userSession.userId!));
                context.read<PackageBloc>().add(FetchPackages());
                context.read<FiveXBloc>().add(FetchFiveX());
                context.read<ReferralBloc>().add(LoadReferrals(userSession.userId!));
                context.read<MyTeamBloc>().add(FetchMyTeam(userSession.userId!));
              }
            }
          } else if (state is PackagePaymentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("❌ Error: ${state.error}")),
            );
          }
        },
        builder: (context, state) {
          final totalAmount = package.discountedPrice + package.deposit;
          final halfAmount = totalAmount / 2;

          return ValueListenableBuilder<String>(
            valueListenable: selectedOptionNotifier,
            builder: (context, selectedOption, _) {
              final subAmount =
              selectedOption == "full" ? totalAmount : halfAmount;

              return Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ₹ ${formatPrice(totalAmount)}',
                        style: textStyle16(context)),
                    15.height,
                    Text('Select Payment Option',
                        style: textStyle12(
                            context, color: CustomColor.descriptionColor)),
                    CustomContainer(
                      border: true,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _radioOption(
                            context,
                            title: "Full Payment",
                            amount: formatPrice(totalAmount),
                            value: "full",
                            groupValue: selectedOption,
                            onChanged: (v) => selectedOptionNotifier.value = v!,
                          ),
                          _radioOption(
                            context,
                            title: "Half Payment",
                            amount: formatPrice(halfAmount),
                            value: "half",
                            groupValue: selectedOption,
                            onChanged: (v) => selectedOptionNotifier.value = v!,
                          ),
                        ],
                      ),
                    ),
                    20.height,
                    if (state is PackagePaymentLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Center(
                                child: Text(
                                  'Cancel',
                                  style: textStyle14(context,
                                      color: CustomColor.redColor),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: CustomContainer(
                              color: CustomColor.appColor,
                              padding:
                              const EdgeInsets.symmetric(vertical: 8),
                              onTap: () {
                                final orderId =
                                    "package_${DateTime.now().millisecondsSinceEpoch}";
                                final model = PackageBuyPaymentModel(
                                  subAmount: subAmount.round(),
                                  isPartialPaymentAllowed:
                                  selectedOption == "half",
                                  description: "Fetch True Payment",
                                  orderId: orderId,
                                  customer: Customer(
                                    customerId: user.id,
                                    customerName: user.fullName,
                                    customerEmail: user.email,
                                    customerPhone: user.mobileNumber,
                                  ),
                                  udf: Udf(
                                    udf1: orderId,
                                    udf2: '',
                                    udf3: user.id,
                                  ),
                                );

                                context.read<PackagePaymentBloc>().add(
                                    CreatePaymentLinkEvent(model));
                              },
                              child: Center(
                                child: Text(
                                  'Proceed to Pay',
                                  style: textStyle14(context,
                                      color: CustomColor.whiteColor),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );

  return paymentSuccess;
}

Widget _radioOption(
    BuildContext context, {
      required String title,
      required String amount,
      required String value,
      required String groupValue,
      required ValueChanged<String?> onChanged,
    }) {
  return Row(
    children: [
      Radio<String>(
        value: value,
        activeColor: CustomColor.appColor,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textStyle12(context)),
          CustomAmountText(amount: amount),
        ],
      ),
    ],
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



