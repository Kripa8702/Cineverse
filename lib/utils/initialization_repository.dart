import 'package:solguruz_practical_task/utils/colored_logs.dart';
import 'package:solguruz_practical_task/utils/dio_client.dart';

class InitializationRepository {
  late DioClient dioClient;

  Future<void> init() async {
    dioClient = DioClient();
    ColoredLogs.success("::::::::::::::::::::: DioClient Initialized :::::::::::::::::::::");
  }
}
