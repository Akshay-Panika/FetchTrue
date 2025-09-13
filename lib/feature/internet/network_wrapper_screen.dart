import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/feature/banner/bloc/banner/banner_bloc.dart';
import 'package:fetchtrue/feature/banner/bloc/banner/banner_event.dart';
import 'package:fetchtrue/feature/lead/bloc/lead/lead_bloc.dart';
import 'package:fetchtrue/feature/lead/bloc/lead/lead_event.dart';
import 'package:fetchtrue/feature/offer/bloc/offer_bloc.dart';
import 'package:fetchtrue/feature/offer/bloc/offer_event.dart';
import 'package:fetchtrue/feature/profile/bloc/user/user_bloc.dart';
import 'package:fetchtrue/feature/profile/bloc/user/user_event.dart';
import 'package:fetchtrue/feature/team_build/bloc/my_team/my_team_bloc.dart';
import 'package:fetchtrue/feature/wallet/bloc/wallet_bloc.dart';
import 'package:fetchtrue/feature/wallet/bloc/wallet_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../auth/user_notifier/user_notifier.dart';
import '../home/bloc/understanding_ft/understanding_fetch_true_bloc.dart';
import '../home/bloc/understanding_ft/understanding_fetch_true_event.dart';
import '../module/bloc/module_bloc.dart';
import '../module/bloc/module_event.dart';
import '../team_build/bloc/my_team/my_team_event.dart';

/// 🌍 Global Network Monitor
class NetworkMonitor {
  static final ValueNotifier<bool> isConnected = ValueNotifier(true);

  static void init(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final userId = userSession.userId;

    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      isConnected.value = connected;

      if (connected && userId != null) {
        // context.read<UserBloc>().add(GetUserById(userId));
        // context.read<ModuleBloc>().add(GetModules());
        // context.read<BannerBloc>().add(GetBanners());
        // context.read<WalletBloc>().add(FetchWalletByUserId(userId));
        // context.read<MyTeamBloc>().add(FetchMyTeam(userId));
        // context.read<OfferBloc>().add(FetchOffersEvent());
        // context.read<UnderstandingFetchTrueBloc>().add(LoadUnderstandingFetchTrue());
        // context.read<LeadBloc>().add(FetchLeadsByUser(userId));
      }
    });
  }
}


class NetworkWrapper extends StatelessWidget {
  final Widget child;
  const NetworkWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NetworkMonitor.isConnected,
      builder: (context, connected, _) {
        return Stack(
          children: [
            child,
            if (!connected)
              Positioned.fill(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Icon(Icons.wifi_off, color: CustomColor.iconColor, size: 50),
                        SizedBox(height: 12),
                        Text(
                          "No Internet Connection",style: textStyle14(context, color: CustomColor.descriptionColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
