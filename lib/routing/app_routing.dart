import 'package:solguruz_practical_task/features/movie_details/view/movie_details_screen.dart';
import 'package:solguruz_practical_task/features/movies/view/movies_screen.dart';
import 'package:solguruz_practical_task/features/splash/view/splash_screen.dart';
import 'package:solguruz_practical_task/services/navigator_service.dart';
import 'package:go_router/go_router.dart';

class AppRouting {
  static const String splashPath = '/';

  static const String moviesPath = '/movies';

  static const String movieDetailsPath = '/movieDetails';

  static final GoRouter router = GoRouter(
    navigatorKey: NavigatorService.navigatorKey,
    routes: [
      GoRoute(
        path: splashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: moviesPath,
        builder: (context, state) => const MoviesScreen(),
      ),
      GoRoute(
        path: movieDetailsPath,
        builder: (context, state) => MovieDetailsScreen(
          movieId: (state.extra as Map<String, dynamic>)['movieId'] as int,
        ),
      ),
    ],
  );
}
