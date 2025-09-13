import 'package:fetchtrue/helper/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/costants/custom_color.dart';
import 'feature/auth/user_notifier/user_notifier.dart';
import 'feature/banner/bloc/banner/banner_bloc.dart';
import 'feature/banner/bloc/banner/banner_event.dart';
import 'feature/banner/repository/banner_repository.dart';
import 'feature/internet/network_wrapper_screen.dart';
import 'feature/lead/bloc/lead/lead_bloc.dart';
import 'feature/lead/repository/lead_repository.dart';
import 'feature/profile/bloc/user/user_bloc.dart';
import 'feature/profile/repository/user_repository.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final userSession = UserSession();
  await userSession.loadUserSession();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserSession>.value(value: userSession),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UserBloc(UserRepository())),
            BlocProvider(create: (_) => BannerBloc(BannerRepository())..add(GetBanners())),
            BlocProvider(create: (_) => LeadBloc(LeadRepository())),
          ],
          child: const MyApp(),
        ),
      )
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    NetworkMonitor.init(context);
    return MaterialApp.router(
      title: 'Fetch True',
      debugShowCheckedModeBanner: false,
      // home:  SplashScreen(),
      routerConfig: router,
      theme: ThemeData(
        scaffoldBackgroundColor: CustomColor.canvasColor,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: CustomColor.iconColor),
          actionsIconTheme: IconThemeData(color: CustomColor.iconColor),
          titleTextStyle: TextStyle(
            fontSize: 16,
            color: CustomColor.appColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
