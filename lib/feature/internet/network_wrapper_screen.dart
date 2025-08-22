import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// 🌍 Global Network Monitor
class NetworkMonitor {
  static final ValueNotifier<bool> isConnected = ValueNotifier(true);

  static void init() {
    InternetConnectionChecker.instance.onStatusChange.listen((status) {
      final connected = status == InternetConnectionStatus.connected;
      isConnected.value = connected;
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
