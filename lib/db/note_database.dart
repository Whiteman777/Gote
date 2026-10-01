import 'package:floor/floor.dart';
import 'package:gote/db/daos/note_dao.dart';

import 'entities/note.dart';

@Database(version: 1, entities: [Note])
abstract class NoteDatabase extends FloorDatabase {
  NoteDao get notedao;
}
