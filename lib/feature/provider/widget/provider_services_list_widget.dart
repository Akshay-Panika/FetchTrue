import 'package:fetchtrue/feature/provider/widget/service_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_service_list.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';

class ProviderServicesListWidget extends StatelessWidget {
  const ProviderServicesListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
            color: CustomColor.appColor.withOpacity(0.1),
            child: CustomServiceList(headline: 'Best Service')),
        Container(
            color: CustomColor.blueColor.withOpacity(0.1),
            child: CustomServiceList(headline: 'Popular Service')),


        /// Services
        BlocProvider(
          create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
          child:  BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
            builder: (context, state) {
              if (state is ModuleServiceLoading) {
                return Center(child: LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,),);
              }

              else if(state is ModuleServiceLoaded){

                final services = state.serviceModel;
                // final services = state.serviceModel.where((moduleService) =>
                // moduleService.subcategory.id ==
                // ).toList();

                if (services.isEmpty) {
                  return const Center(child: Text('No Service found.'));
                }

                return  Container(
                    color: CustomColor.greenColor.withOpacity(0.1),
                    child: ServiceWidget(headline: 'All Service', service: services,));

              }

              else if (state is ModuleServiceError) {
                return Center(child: Text(state.errorMessage));
              }
              return const SizedBox.shrink();
            },
          ),
        ),

      ],
    );
  }
}
