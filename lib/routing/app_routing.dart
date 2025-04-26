import 'package:solguruz_practical_task/features/splash/view/splash_screen.dart';
import 'package:solguruz_practical_task/services/navigator_service.dart';
import 'package:go_router/go_router.dart';

/// NOTE:
/// * Navigate using path names
/// * To go to auth startup : use NavigatorService.go(AppRouting.authPath)
/// * ---- To go to screens within the auth path, use NavigatorService.push(AppRouting.loginPath)

class AppRouting {
  static const String splashPath = '/';


  static final GoRouter router = GoRouter(
    navigatorKey: NavigatorService.navigatorKey,
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
    ],
  );
}
