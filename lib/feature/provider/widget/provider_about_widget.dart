import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/costants/custom_color.dart';
import '../bloc/provider_by_id/provider_by_id_bloc.dart';
import '../bloc/provider_by_id/provider_by_id_event.dart';
import '../bloc/provider_by_id/provider_by_id_state.dart';
import '../repository/provider_by_id_service.dart';

class ProviderAboutWidget extends StatelessWidget {
  final String providerId;
  ProviderAboutWidget({super.key, required this.providerId});

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

              final data = state.provider;

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provider : ${data.fullName}'),
                    // Text('Contact : ${data.phoneNo}'),
                    Text('Email Id : ${data.email}'),

                    Text('About : ${''}'),
                  ],
                ),
              );
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