import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';

class PackageScreen extends StatelessWidget {
  const PackageScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final userSession = Provider.of<UserSession>(context);

    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Packages',
          showBackButton: true,
        ),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Packages', showBackButton: true),

    );
  }
}
