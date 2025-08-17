import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/costants/custom_color.dart';
import 'feature/auth/screen/splash_screen.dart';
import 'feature/auth/user_notifier/user_notifier.dart';
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
        BlocProvider(create: (_) => UserBloc(UserRepository())),
      ],
      child: const MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final userSession = Provider.of<UserSession>(context, listen: false).loadUserSession();
    final userSession = Provider.of<UserSession>(context);

    return MaterialApp(
      title: 'Fetch True',
      debugShowCheckedModeBanner: false,
      home: userSession.isLoggedIn ? const SplashScreen() : const SplashScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
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
