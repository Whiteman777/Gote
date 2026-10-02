import 'package:gote/domain/location/map_link.dart';

abstract interface class MapLauncher {
  Future<bool> open(MapLink link);
}
