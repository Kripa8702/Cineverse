import 'package:solguruz_practical_task/utils/colored_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {
  const SimpleBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    ColoredLogs.error(error.toString());
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    ColoredLogs.info("CURRENT ${change.currentState.toString()}");
    ColoredLogs.info("NEXT ${change.nextState.toString()}");
    super.onChange(bloc, change);
  }
}
