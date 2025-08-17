import 'package:fetchtrue/feature/provider/widget/service_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';
import '../model/provider_model.dart';

class ProviderServicesListWidget extends StatelessWidget {
  final ProviderModel data;
  const ProviderServicesListWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return  ListView(
      physics: NeverScrollableScrollPhysics(),
      children: [
        /// Services
        BlocProvider(
          create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
          child:  BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
            builder: (context, state) {
              if (state is ModuleServiceLoading) {
                return Padding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Center(child: CircularProgressIndicator(color: CustomColor.appColor,),),
                );
              }

              else if(state is ModuleServiceLoaded){


                final subscribedIds = data.subscribedServices.map((s) => s.id).toSet();

                final services = state.serviceModel.where((service) =>
                    subscribedIds.contains(service.id)).toList();

                if (services.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: const Center(child: Text('No Service found.')),
                  );
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
