import 'package:floor/floor.dart';

@Entity(tableName: "notes")
class Note {
  @PrimaryKey(autoGenerate: true)
  final int? noteid = null;
  final String name;
  final String body;
  final int createdAt, updatedAt;
  final int locationCapturedAt;
  final double latitude, longtitude, accuracy;

  const Note({
    required this.body,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.locationCapturedAt,
    required this.accuracy,
    required this.latitude,
    required this.longtitude,
  });
}
