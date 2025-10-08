import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../feature/auth/screen/splash_screen.dart';
import '../feature/category/business/screen/business_screen.dart';
import '../feature/category/education/screen/education_screen.dart';
import '../feature/category/finance/screen/finance_service_screen.dart';
import '../feature/category/franchise/screen/franchise_screen.dart';
import '../feature/category/it_service/screen/it_service_screen.dart';
import '../feature/category/legal_service/screen/legal_service_screen.dart';
import '../feature/category/marketing/screen/marketing_screen.dart';
import '../feature/category/onboarding/screen/onboarding_screen.dart';
import '../feature/category/ondemand/screen/ondemand_screen.dart';
import '../feature/dashboard/screen/dashboard_screen.dart';
import '../feature/provider/screen/provider__details_screen.dart';
import '../feature/service/screen/service_details_screen.dart';
import '../feature/subcategory/screen/subcategory_screen.dart';
import '../feature/team_build/screen/team_build_screen.dart';
import '../feature/wallet/screen/wallet_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // Dashboard
    GoRoute(
      path: '/dashboard',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const DashboardScreen(),
        transitionsBuilder: _fadeTransition,
      ),
    ),

    // Franchise
    GoRoute(
      path: '/franchise/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: FranchiseScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Business
    GoRoute(
      path: '/business/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: BusinessScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Marketing
    GoRoute(
      path: '/marketing/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: MarketingScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Legal Services
    GoRoute(
      path: '/legal/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: LegalServiceScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Finance
    GoRoute(
      path: '/finance/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: FinanceServiceScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // IT Services
    GoRoute(
      path: '/it/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: ItServiceScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Education
    GoRoute(
      path: '/education/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: EducationScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // On-Demand Services
    GoRoute(
      path: '/ondemand/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: OnDemandScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Onboarding
    GoRoute(
      path: '/onboarding/:moduleId',
      pageBuilder: (context, state) {
        final moduleId = state.pathParameters['moduleId']!;
        final imageUrl = state.uri.queryParameters['image'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: OnboardingScreen(moduleId: moduleId, imageUrl: imageUrl),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    // Subcategory
    GoRoute(
      path: '/subcategory/:categoryId',
      pageBuilder: (context, state) {
        final categoryId = state.pathParameters['categoryId']!;
        final categoryName = state.uri.queryParameters['name'] ?? '';
        return CustomTransitionPage(
          key: state.pageKey,
          child: SubcategoryScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),


    // Service Details
    GoRoute(
      path: '/service/:serviceId',
      pageBuilder: (context, state) {
        final serviceId = state.pathParameters['serviceId']!;
        final providerId = state.extra as String?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ServiceDetailsScreen(serviceId: serviceId,  providerId: providerId.toString(),),
          transitionsBuilder: _fadeTransition,
        );
      },
    ),

    GoRoute(
      path: '/wallet/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return WalletScreen(userId: userId);
      },
    ),

    GoRoute(
      path: '/my-team',
      builder: (context, state) => const TeamBuildScreen(),
    ),


    /// Provider
    GoRoute(
      path: '/provider/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final name = state.uri.queryParameters['name'];
        return ProviderDetailsScreen(
          providerId: id,
          storeName: name ?? '',
        );
      },
    ),


  ],
);

Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
    ) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeInOut,
  );

  return FadeTransition(
    opacity: curvedAnimation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.05, 0),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    ),
  );
}


// Widget _fadeTransition(
//     BuildContext context,
//     Animation<double> animation,
//     Animation<double> secondaryAnimation,
//     Widget child,
//     ) {
//   // Curved animation for smoothness
//   final curvedAnimation = CurvedAnimation(
//     parent: animation,
//     curve: Curves.easeInOut,
//   );
//
//   return FadeTransition(
//     opacity: curvedAnimation,
//     child: child,
//   );
// }





