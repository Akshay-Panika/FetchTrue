import 'package:fetchtrue/feature/my_lead/screen/leads_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_network_mage.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../category/business/screen/business_screen.dart';
import '../../category/education/screen/education_screen.dart';
import '../../category/finance/screen/finance_service_screen.dart';
import '../../category/franchise/screen/franchise_screen.dart';
import '../../category/it_service/screen/it_service_screen.dart';
import '../../category/legal_service/screen/legal_service_screen.dart';
import '../../category/marketing/screen/marketing_screen.dart';
import '../../category/onboarding/screen/onboarding_screen.dart';
import '../../category/ondemand/screen/ondemand_screen.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_state.dart';

class ModuleWidget extends StatelessWidget {
  const ModuleWidget({super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.height,

        Padding(
          padding:  EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.apps, size: 19, color: CustomColor.appColor),5.width,
              Text('Modules', style: textStyle14(context, color: CustomColor.appColor),),
              10.width,
              Expanded(child: Divider(color: CustomColor.appColor,))
            ],
          ),
        ),
        15.height,
        BlocBuilder<ModuleBloc, ModuleState>(
          builder: (context, state) {
            if (state is ModuleLoading) {
              return ModuleShimmer();
            } else if (state is ModuleLoaded) {
              final modules = state.modules;
              // final modules = state.modules.where((module) => module.categoryCount != 0).toList();
              return  GridView.builder(
                itemCount: modules.length,
                shrinkWrap: true,
                padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.11 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                ),
                itemBuilder: (context, index) {
                  final module = modules[index];
                  return CustomContainer(
                    border: true,
                    margin: EdgeInsets.zero,
                    color: Colors.white,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        Expanded(
                          child: Hero(
                            tag: module.id,
                            child: Material( // 👈 ye add karo
                              color: Colors.transparent,
                              child: CustomNetworkImage(
                                borderRadius: BorderRadius.circular(10),
                                imageUrl: module.image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(module.name, style: textStyle12(context),overflow: TextOverflow.clip,textAlign: TextAlign.center,),
                        ),
                        5.height,
                      ],
                    ),
                    onTap: () {
                      final Map<String, Widget> categoryWidgets = {
                        'Franchise': FranchiseScreen(moduleId: module.id, imageUrl: module.image,),
                        'Business': BusinessScreen(moduleId: module.id, imageUrl: module.image),
                        'Marketing': MarketingScreen(moduleId: module.id, imageUrl: module.image, ),
                        'Legal Services': LegalServiceScreen(moduleId: module.id, imageUrl: module.image,),
                        'Finance': FinanceServiceScreen(moduleId: module.id, imageUrl: module.image,),
                        'It Services': ItServiceScreen(moduleId: module.id,imageUrl: module.image,),
                        'Education': EducationScreen(moduleId: module.id, imageUrl: module.image),
                        'On-Demand Services': OnDemandScreen(moduleId: module.id, imageUrl: module.image),
                        'Onboarding': OnboardingScreen(moduleId: module.id, imageUrl: module.image),
                      };

                      final screen = categoryWidgets[module.name];

                      if (screen != null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => screen),);
                      }
                      else {
                        showCustomToast('Module "${module.name}" not found');
                      }
                    },
                  );
                },
              );
            } else if (state is ModuleError) {
              print("Modules : ${state.message}");
            }
            return Container();
          },
        )
      ],
    );
  }
}


/// Shimmer effect
class ModuleShimmer extends StatelessWidget {
  const ModuleShimmer({super.key});

  static const _itemCount = 9;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _itemCount,
      shrinkWrap: true,
      padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.11 / 1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, __) => CustomContainer(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: ShimmerBox(height: 10, width: 80,),
            ),
          ],
        ),
      ),
    );
  }
}