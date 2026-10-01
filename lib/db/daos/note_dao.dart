import 'package:floor/floor.dart';

@dao
abstract class NoteDao {
  @Query("select body from notes")
  Future<List<String>> getBody();
}
