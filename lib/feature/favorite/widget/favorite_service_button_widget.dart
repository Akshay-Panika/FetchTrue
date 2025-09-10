import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../bloc/service/favorite_service_bloc.dart';
import '../bloc/service/favorite_service_event.dart';
import '../bloc/service/favorite_service_state.dart';


class FavoriteServiceButtonWidget extends StatelessWidget {
  final String serviceId;
  const FavoriteServiceButtonWidget({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const SizedBox.shrink();
        } else if (state is UserLoaded) {
          final user = state.user;
          final isFavorite = user.favoriteServices.contains(serviceId);

          return BlocConsumer<FavoriteBloc, FavoriteState>(
            listenWhen: (previous, current) =>
            current is FavoriteSuccess || current is FavoriteFailure,
            listener: (context, favState) {
              if (favState is FavoriteSuccess && favState.serviceId == serviceId) {
                context.read<UserBloc>().add(GetUserById(userSession.userId!));
              }
            },
            builder: (context, favState) {
              if (favState is FavoriteLoading && favState.serviceId == serviceId) {
                return const SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 3, color: Colors.red),
                  ),
                );
              }

              return InkWell(
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onTap: () {
                  if (isFavorite) {
                    context.read<FavoriteBloc>().add(RemoveFavoriteEvent(user.id, serviceId));
                  } else {
                    context.read<FavoriteBloc>().add(AddFavoriteEvent(user.id, serviceId));
                  }
                },
              );
            },
          );
        } else if (state is UserError) {
           return Icon(Icons.favorite_border, color: Colors.red,);
        }

         return Icon(Icons.favorite_border, color: Colors.red,);
      },
    );
  }
}
