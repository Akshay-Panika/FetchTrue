import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../../banner/model/banner_model.dart';
import '../../module/bloc/module_bloc.dart';
import '../../module/bloc/module_event.dart';
import '../../module/bloc/module_state.dart';
import '../../module/repository/module_repository.dart';
import '../../provider/bloc/provider/provider_bloc.dart';
import '../../provider/bloc/provider/provider_event.dart';
import '../../provider/bloc/provider/provider_state.dart';
import '../../provider/model/provider_model.dart';
import '../../provider/repository/provider_repository.dart';

class ProviderCardWidget extends StatelessWidget {
  final String? providerId;
  const ProviderCardWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    if (providerId == null || providerId!.isEmpty) {
      return SizedBox.shrink();
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviderById(providerId!))),
        BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules())),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProviderBloc, ProviderState>(listener: (context, state) {
            if (state is ProviderError) debugPrint('Provider Error: ${state.message}');
          },),

          BlocListener<ModuleBloc, ModuleState>(listener: (context, state) {
            if (state is ModuleError) debugPrint('Module Error: ${state.message}');
          },),

        ],
        child: Builder(
          builder: (context) {

            final providerState = context.watch<ProviderBloc>().state;
            final moduleState = context.watch<ModuleBloc>().state;

            if(providerState is ProviderLoading || moduleState is ModuleLoading){
              return  LinearProgressIndicator(color: CustomColor.appColor,minHeight: 1,);
            }
            if (providerState is ProviderLoaded && moduleState is ModuleLoaded) {
              final provider = providerState.provider;
              final modules = moduleState.modules;

              if (provider == null || provider.kycCompleted != true) {
                return const Center(child: Text("Provider not available"));
              }

              final selectedModule = modules.firstWhere(
                    (m) => m.id == provider.storeInfo?.module, // fallback
              );


              return CustomContainer(
             border: true,
             color: CustomColor.whiteColor,
             margin: EdgeInsets.zero,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text('Service Provider', style: textStyle14(context)),
                 10.height,
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         CircleAvatar(
                           radius: 30,
                           backgroundColor: CustomColor.greyColor.withOpacity(0.2),
                           backgroundImage: (provider.storeInfo?.logo != null &&
                               provider.storeInfo!.logo!.isNotEmpty &&
                               Uri.tryParse(provider.storeInfo!.logo!)?.hasAbsolutePath == true)
                               ? NetworkImage(provider.storeInfo!.logo!)
                               : AssetImage(CustomImage.nullImage) as ImageProvider,
                         ),
                         10.width,
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               provider.storeInfo?.storeName ??
                                   'No Provider Available',
                               style: textStyle14(context),
                             ),
                             Text(
                               selectedModule?.name ?? 'Unknown',
                               style: textStyle14(
                                 context,
                                 fontWeight: FontWeight.w400,
                                 color: CustomColor.descriptionColor,
                               ),
                             ),
                             5.height,
                             if (provider.storeInfo?.storePhone != null &&
                                 provider.storeInfo!.storePhone!.isNotEmpty)
                               Text(
                                 'Contact: +91 ${provider.storeInfo!.storePhone}',
                                 style: textStyle12(
                                   context,
                                   color: CustomColor.descriptionColor,
                                 ),
                               ),
                           ],
                         ),
                       ],
                     ),
                     Padding(
                       padding: const EdgeInsets.only(right: 10.0),
                       child: Row(
                         children: [
                           InkWell(
                             onTap: () => ContactHelper.whatsapp(
                               provider.phoneNo ?? '',
                               'Dear Provider\n${provider.fullName ?? ''}',
                             ),
                             child: Image.asset(
                               CustomIcon.whatsappIcon,
                               height: 25,
                             ),
                           ),
                           40.width,
                           InkWell(
                             onTap: () {
                               if (provider.storeInfo?.storePhone != null &&
                                   provider.storeInfo!.storePhone!.isNotEmpty) {
                                 ContactHelper.call(
                                     provider.storeInfo!.storePhone!);
                               } else {
                                 ScaffoldMessenger.of(context).showSnackBar(
                                   const SnackBar(
                                     content:
                                     Text('Phone number not available'),
                                   ),
                                 );
                               }
                             },
                             child: Image.asset(
                               CustomIcon.phoneIcon,
                               height: 25,
                               color: CustomColor.appColor,
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
                 5.height,
                 Text(
                   '⭐ ${provider.totalReviews ?? 0} (${provider.totalReviews ?? 0} Reviews)',
                   style: const TextStyle(fontSize: 12, color: Colors.black),
                 ),
               ],
             ),
           );

         }
            return const SizedBox.shrink();
          }
        ),
      ),
    );
  }
}
