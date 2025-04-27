import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solguruz_practical_task/models/hive_models/hive_genre_model.dart';
import 'package:solguruz_practical_task/models/hive_models/hive_movie_model.dart';
import 'package:solguruz_practical_task/services/hive_service.dart';
import 'package:solguruz_practical_task/simple_bloc_observer.dart';
import 'package:solguruz_practical_task/solguruz_practical_task_app.dart';
import 'package:solguruz_practical_task/theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: backgroundColor,
  ));

  Bloc.observer = const SimpleBlocObserver();

  // Hive initialization
  await Hive.initFlutter();
  Hive.registerAdapter(HiveMovieAdapter());
  Hive.registerAdapter(HiveGenreModelAdapter());
  await HiveService.openHiveMoviesBox();

  Future.wait([
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]),
  ]).then(
    (value) {
      runApp(
        const SolguruzPracticalTaskApp(),
      );
    },
  );
}
