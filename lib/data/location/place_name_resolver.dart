import 'package:geocoding/geocoding.dart';
import 'package:gote/domain/location/place_name.dart';

abstract interface class PlaceNameResolver {
  Future<String?> nameFor({
    required double latitude,
    required double longitude,
  });
}

class GeocodingPlaceNameResolver implements PlaceNameResolver {
  const GeocodingPlaceNameResolver();

  @override
  Future<String?> nameFor({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final List<Placemark> marks = await Geocoding().placemarkFromCoordinates(
        latitude,
        longitude,
      );
      if (marks.isEmpty) {
        return null;
      }
      return buildPlaceName(
        subLocality: marks.first.subLocality,
        locality: marks.first.locality,
        subAdministrativeArea: marks.first.subAdministrativeArea,
        administrativeArea: marks.first.administrativeArea,
        thoroughfare: marks.first.thoroughfare,
        country: marks.first.country,
      );
    } catch (_) {
      return null;
    }
  }
}

class NoopPlaceNameResolver implements PlaceNameResolver {
  const NoopPlaceNameResolver();

  @override
  Future<String?> nameFor({
    required double latitude,
    required double longitude,
  }) async => null;
}
