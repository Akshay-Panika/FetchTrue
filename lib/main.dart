import 'package:fetchtrue/feature/provider/bloc/provider/provider_bloc.dart';
import 'package:fetchtrue/feature/provider/repository/provider_repository.dart';
import 'package:fetchtrue/feature/team_build/bloc/user_confirm_referral/user_confirm_referral_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'core/costants/custom_color.dart';
import 'feature/auth/screen/splash_screen.dart';
import 'feature/auth/user_notifier/user_notifier.dart';
import 'feature/banner/bloc/banner/banner_bloc.dart';
import 'feature/banner/bloc/banner/banner_event.dart';
import 'feature/banner/repository/banner_repository.dart';
import 'feature/category/bloc/category_bloc.dart';
import 'feature/category/bloc/category_event.dart';
import 'feature/category/repository/category_repository.dart';
import 'feature/checkout/bloc/checkout/checkout_bloc.dart';
import 'feature/checkout/bloc/commission/commission_bloc.dart';
import 'feature/checkout/bloc/commission/commission_event.dart';
import 'feature/checkout/repository/checkout_repository.dart';
import 'feature/favorite/bloc/favorite_service_bloc.dart';
import 'feature/favorite/repository/favorite_service_repository.dart';
import 'feature/five_x/bloc/five_x/FiveXBloc.dart';
import 'feature/five_x/bloc/five_x/FiveXEvent.dart';
import 'feature/five_x/repository/FiveXRepository.dart';
import 'feature/highlight_serive/bloc/ads_bloc.dart';
import 'feature/highlight_serive/bloc/ads_event.dart';
import 'feature/highlight_serive/repository/ads_repository.dart';
import 'feature/home/bloc/understanding_ft/understanding_fetch_true_bloc.dart';
import 'feature/home/bloc/understanding_ft/understanding_fetch_true_event.dart';
import 'feature/home/repository/understanding_fetch_true_repository.dart';
import 'feature/internet/network_wrapper_screen.dart';
import 'feature/lead/bloc/lead/lead_bloc.dart';
import 'feature/lead/bloc/leads_status/lead_status_bloc.dart';
import 'feature/lead/repository/lead_repository.dart';
import 'feature/lead/repository/lead_status_repository.dart';
import 'feature/module/bloc/module_bloc.dart';
import 'feature/module/bloc/module_event.dart';
import 'feature/module/repository/module_repository.dart';
import 'feature/offer/bloc/offer_bloc.dart';
import 'feature/offer/bloc/offer_event.dart';
import 'feature/package/bloc/package/package_bloc.dart';
import 'feature/package/bloc/package/package_event.dart';
import 'feature/profile/bloc/additional_details/additional_details_bloc.dart';
import 'feature/profile/bloc/user/user_bloc.dart';
import 'feature/profile/bloc/user_by_id/user_by_id_bloc.dart';
import 'feature/profile/repository/additinal_details_repository.dart';
import 'feature/profile/repository/user_by_id_repojetory.dart';
import 'feature/profile/repository/user_repository.dart';
import 'feature/provider/bloc/provider/provider_event.dart';
import 'feature/service/bloc/service/service_bloc.dart';
import 'feature/service/bloc/service/service_event.dart';
import 'feature/service/repository/service_repository.dart';
import 'feature/subcategory/bloc/module_subcategory/subcategory_bloc.dart';
import 'feature/subcategory/bloc/module_subcategory/subcategory_event.dart';
import 'feature/subcategory/repository/subcategory_repository.dart';
import 'feature/team_build/bloc/my_team/my_team_bloc.dart';
import 'feature/team_build/bloc/user_referral/user_referral_bloc.dart';
import 'feature/team_build/repository/my_team_repository.dart';
import 'feature/team_build/repository/user_referral_repository.dart';
import 'feature/wallet/bloc/wallet_bloc.dart';
import 'feature/wallet/repository/wallet_repository.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  NetworkMonitor.init();
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
            BlocProvider(create: (_) => AdditionalDetailsBloc(service: UserAdditionalDetailsService(),),),
            BlocProvider(create: (_) => ProviderBloc(ProviderRepository())..add(GetProviders())),
            BlocProvider(create: (_) => BannerBloc(BannerRepository())..add(GetBanners())),
            BlocProvider(create: (_) => ModuleBloc(ModuleRepository())..add(GetModules())),
            BlocProvider(create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories())),
            BlocProvider(create: (_) => SubcategoryBloc(SubcategoryRepository())..add(FetchSubcategories()),),
            BlocProvider(create: (_) => ServiceBloc(ServiceRepository())..add(GetServices())),
            BlocProvider(create: (_) => CommissionBloc()..add(GetCommission())),
            BlocProvider(create: (_) => CheckoutBloc(repository: CheckOutRepository())),
            BlocProvider(create: (_) => LeadBloc(LeadRepository())),
            BlocProvider(create: (_) => LeadStatusBloc(LeadStatusRepository())),
            BlocProvider(create: (_) => PackageBloc()..add(FetchPackages()),),
            BlocProvider(create: (_) => WalletBloc(WalletRepository()),),
            BlocProvider(create: (_) => UserReferralBloc(UserReferralRepository()),),
            BlocProvider(create: (_) => UserConfirmReferralBloc(UserReferralRepository()),),
            BlocProvider(create: (_) => UserByIdBloc(UserByIdRepository())),
            BlocProvider(create: (_) => MyTeamBloc(MyTeamRepository())),
            BlocProvider(create: (_) => OfferBloc()..add(FetchOffersEvent())),
            BlocProvider(create: (_) => AdsBloc(AdsRepository())..add(LoadAdsEvent())),
            BlocProvider(create: (_) => UnderstandingFetchTrueBloc(UnderstandingFetchTrueRepository())..add(LoadUnderstandingFetchTrue())),
            BlocProvider(create: (_) => FavoriteBloc(FavoriteRepository())),
            BlocProvider(create: (_) => FiveXBloc(FiveXRepository())..add(FetchFiveX())),
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

    // final userSession = Provider.of<UserSession>(context, listen: false).loadUserSession();
    // final userSession = Provider.of<UserSession>(context);

    return MaterialApp(
      title: 'Fetch True',
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
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
