import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_container.dart';
import '../bloc/provider_by_id/provider_by_id_bloc.dart';
import '../bloc/provider_by_id/provider_by_id_event.dart';
import '../bloc/provider_by_id/provider_by_id_state.dart';
import '../repository/provider_by_id_service.dart';

class ProviderGalleryWidget extends StatelessWidget {
  final String providerId;
  const ProviderGalleryWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: BlocProvider(
        create: (_) => ProviderByIdBloc(ProviderByIdService())..add(GetProviderByIdEvent(providerId.toString())),
        child:  BlocBuilder<ProviderByIdBloc, ProviderByIdState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Center(child: CircularProgressIndicator(color: CustomColor.appColor,),),
              );
            }

            else if(state is ProviderLoaded){

              final gallery = state.provider.galleryImages;

              return  GridView.builder(
                itemCount: gallery.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {

                  return CustomContainer(border: true,
                    color: Colors.white,
                    networkImg: gallery[index],
                  );
                },);
            }

            else if (state is ProviderError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
