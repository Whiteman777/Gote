import 'package:gote/domain/location/location_outcome.dart';

abstract interface class LocationRepository {
  Future<LocationOutcome> currentFix();

  Future<bool> openSettings();
}
