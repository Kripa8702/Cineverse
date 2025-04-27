import 'package:hive/hive.dart';
import 'package:solguruz_practical_task/models/genre_model.dart';

part 'hive_genre_model.g.dart';

@HiveType(typeId: 1)
class HiveGenre {
  HiveGenre({
    required this.id,
    required this.name,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;
}

extension GenreMapper on Genre {
  HiveGenre toHiveModel() {
    return HiveGenre(
      id: id,
      name: name,
    );
  }
}

extension HiveGenreMapper on HiveGenre {
  Genre toGenre() {
    return Genre(
      id: id,
      name: name,
    );
  }
}