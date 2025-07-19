import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_headline.dart';
import '../../service/bloc/module_service/module_service_bloc.dart';
import '../../service/bloc/module_service/module_service_event.dart';
import '../../service/bloc/module_service/module_service_state.dart';
import '../../service/repository/api_service.dart';
import '../../service/screen/all_service_screen.dart';
import 'service_card_widget.dart';

class RecommendedServicesWidget extends StatelessWidget {
  final String headline;
  const RecommendedServicesWidget({super.key, required this.headline});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ModuleServiceBloc(ApiService())..add(GetModuleService()),
      child: BlocBuilder<ModuleServiceBloc, ModuleServiceState>(
        builder: (context, state) {
          if (state is ModuleServiceLoading) {
            return SizedBox.shrink();
          } else if (state is ModuleServiceLoaded) {
            // final services = state.serviceModel;
            final services = state.serviceModel
                .where((service) => service.recommendedServices == true)
                .toList();
            if (services.isEmpty) {
              return const Center(child: Text('No Service found.'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomHeadline(headline: headline, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AllServiceScreen(headline: headline, services: services,),)),),
                ServiceCardWidget(
                  services: services,
                )

              ],
            );
          } else if (state is ModuleServiceError) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

