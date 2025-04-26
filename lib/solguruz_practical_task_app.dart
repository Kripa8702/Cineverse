import 'package:solguruz_practical_task/features/movies/cubit/movies_cubit.dart';
import 'package:solguruz_practical_task/features/movies/repository/movies_repository.dart';
import 'package:solguruz_practical_task/features/splash/cubit/splash_cubit.dart';
import 'package:solguruz_practical_task/routing/app_routing.dart';
import 'package:solguruz_practical_task/theme/colors.dart';
import 'package:solguruz_practical_task/utils/initialization_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solguruz_practical_task/utils/size_utils.dart';

class SolguruzPracticalTaskApp extends StatelessWidget {
  const SolguruzPracticalTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<InitializationRepository>(
              lazy: true,
              create: (context) => InitializationRepository()..init(),
            ),
            RepositoryProvider(
              create: (context) => MoviesRepository(
                  dioClient:
                      context.read<InitializationRepository>().dioClient),
            )
          ],
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onVerticalDragDown: (_) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                  overlays: [
                    SystemUiOverlay.top,
                  ]);
            },
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SplashCubit>(
                  create: (context) => SplashCubit(),
                ),
                BlocProvider<MoviesCubit>(
                  create: (context) => MoviesCubit(
                      moviesRepository: context.read<MoviesRepository>()),
                )
              ],
              child: MaterialApp.router(
                routerConfig: AppRouting.router,
                title: 'Cubit Boiler Plate',
                debugShowCheckedModeBanner: false,
                locale: const Locale('en', ''),
                theme: ThemeData(
                  scaffoldBackgroundColor: backgroundColor,
                  dividerColor: borderColor,
                  primaryColor: primaryColor,
                  fontFamily: 'Open Sans',
                  useMaterial3: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
