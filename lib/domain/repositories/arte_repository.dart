import 'package:art_app/domain/models/arte.dart';

abstract class ArteRepository {
  Future<List<Arte>> getAllArteContent();
  Future<void> save(Arte arte);
  Future<void> delete(Arte arte);
  Future<List<Arte>> load();
}