import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/costants/custom_color.dart';
import 'feature/auth/screen/splash_screen.dart';
import 'feature/auth/user_notifier/user_notifier.dart';
import 'feature/profile/bloc/user_bloc/user_bloc.dart';
import 'feature/profile/bloc/user_bloc/user_event.dart';
import 'feature/profile/repository/user_service.dart';
import 'feature/wallet/bloc/wallet_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final userSession = UserSession();
  final userService = UserService();
  final userBloc = UserBloc(userService);

  // 👇 Glue: session triggers bloc when userId is available
  userSession.onUserIdChanged = (userId) {
    userBloc.add(FetchUserById(userId));
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userSession), // ✅ Global UserSession
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WalletBloc>(create: (_) => WalletBloc()),       // ✅ Wallet Bloc
          BlocProvider<UserBloc>.value(value: userBloc),               // ✅ User Bloc (important)
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 Load session on app start (fetches user if session exists)
    Provider.of<UserSession>(context, listen: false).loadUserSession();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      title: 'Fetch True',
      home: const SplashScreen(), // 👈 Splash/Login/Home
    );
  }
}
