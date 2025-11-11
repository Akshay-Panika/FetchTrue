import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/shimmer_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../service/bloc/service/service_bloc.dart';
import '../../../service/bloc/service/service_event.dart';
import '../../../service/bloc/service/service_state.dart';
import '../../../service/repository/service_repository.dart';
import '../../../service/screen/service_details_screen.dart';
import '../../../service/widget/service_card_widget.dart';

class FranchiseRequirementServiceWidget extends StatelessWidget {
  final String moduleId;
  const FranchiseRequirementServiceWidget({super.key, required this.moduleId});

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
      return  BlocProvider(
      create: (_) => ServiceBloc(ServiceRepository())..add(GetServices()),
     child: BlocBuilder<ServiceBloc, ServiceState>(
       builder: (context, state) {
         if (state is ServiceLoading) {
           return _buildShimmer(dimensions);
         }

         else if(state is ServiceLoaded){

           // final services = state.services;
           final services = state.services.where((moduleService) =>
           moduleService.category?.module == moduleId && moduleService.recommendedServices == true
           ).toList();


           if (services.isEmpty) {
             return SizedBox.shrink();
           }


           return  Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Padding(
                 padding:  EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010),
                 child: Text('Recommended Service', style: textStyle12(context),),
               ),
               SizedBox(
                 height: dimensions.screenHeight*0.25,
                 child: ListView(
                   scrollDirection: Axis.horizontal,
                   children: List.generate(services.length, (index) {
                     final data = services[index];

                     return ServiceCardWidget(data: data, providerId: '', isStore: false,);
                   },),
                 ),
               ),
             ],
           );

         }

         else if (state is ServiceError) {
           // print('Dio Error: ${state.message}');
           return Center(child: Text('No Service'));
         }
         return const SizedBox.shrink();
       },
     ),
   );
  }
}


Widget _buildShimmer(Dimensions dimensions){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding:  EdgeInsets.only(top: 10, left: 10),
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ShimmerBox(height: 10, width: dimensions.screenHeight*0.1)),
      ),
      SizedBox(
        height: dimensions.screenHeight*0.25,
        child: ListView.builder(
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
          return CustomContainer(
            margin: EdgeInsets.only(left: dimensions.screenHeight*0.010, top: dimensions.screenHeight*0.010, bottom: dimensions.screenHeight*0.010),
            width: dimensions.screenHeight*0.35,
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.15),
                        5.height,
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.1),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.09),
                        5.height,
                        ShimmerBox(height: 10, width: dimensions.screenHeight*0.050),
                      ],
                    ),
                  ],
                )
                ],
              ),
            ),
          );
        },),
      ),
    ],
  );
}