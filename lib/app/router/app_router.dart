import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/claim/presentation/screens/claim_form_screen.dart';
import '../../features/employee/data/models/employee_model.dart';
import '../../features/employee/presentation/screens/employee_detail_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/splash/presentation/bloc/splash_bloc.dart';
import '../../features/splash/presentation/bloc/splash_event.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_names.dart';
import 'route_paths.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        builder: (context, state) => BlocProvider(
          create: (_) => SplashBloc()..add(SplashStarted()),
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: RoutePaths.directoryDetail,
        name: RouteNames.directoryDetail,
        builder: (context, state) =>
            EmployeeDetailScreen(employee: state.extra as EmployeeModel),
      ),
      GoRoute(
        path: RoutePaths.createClaim,
        name: RouteNames.createClaim,
        builder: (context, state) => const ClaimFormScreen(),
      ),
      GoRoute(
        path: RoutePaths.editClaim,
        name: RouteNames.editClaim,
        builder: (context, state) =>
            ClaimFormScreen(claimId: state.pathParameters['id']),
      ),
    ],
  );
}
