import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'bloc/state.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true,),

      body: BlocBuilder<UBloc, UState>(
        builder: (context, state) {
          if (state is ULoading) return CircularProgressIndicator();
          if (state is ULoaded) {
            final user = state.user;
            return Text("Name: ${user.fullName}");
          }
          return Text("No user data");
        },
      )

    );
  }
}
