import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../bloc/provider/provider_bloc.dart';
import '../bloc/provider/provider_event.dart';
import '../bloc/provider/provider_state.dart';
import '../repository/provider_by_id_service.dart';
import '../repository/provider_repository.dart';

class ProviderAboutWidget extends StatelessWidget {
  final String providerId;
  ProviderAboutWidget({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: BlocProvider(
        create: (_) => ProviderBloc(ProviderRepository())..add(GetProviderById(providerId!)),
        child: BlocBuilder<ProviderBloc, ProviderState>(
          builder: (context, state) {
            if (state is ProviderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProviderLoaded) {
              final provider = state.provider;

              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Provider : ${provider.fullName}'),
                    // Text('Contact : ${data.phoneNo}'),
                    Text('Email Id : ${provider.email}'),

                    Text('About : ${''}'),
                  ],
                ),
              );

            } else if (state is ProviderError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}