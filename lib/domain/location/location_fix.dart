class LocationFix {
  const LocationFix({
    required this.latitude,
    required this.longitude,
    required this.accuracyMetres,
    required this.capturedAt,
    this.placeName,
  });

  final double latitude;
  final double longitude;

  final double accuracyMetres;

  final DateTime capturedAt;

  final String? placeName;

  static String formatCoordinates(double latitude, double longitude) {
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  static String formatAccuracy(double accuracyMetres) {
    if (accuracyMetres <= 0) {
      return '';
    }
    if (accuracyMetres < 1000) {
      return ' ±${accuracyMetres.round()} m';
    }
    return ' ±${(accuracyMetres / 1000).toStringAsFixed(1)} km';
  }

  String get coordinates => formatCoordinates(latitude, longitude);

  String get label =>
      placeName?.trim().isNotEmpty == true ? placeName!.trim() : coordinates;

  LocationFix copyWith({String? placeName}) {
    return LocationFix(
      latitude: latitude,
      longitude: longitude,
      accuracyMetres: accuracyMetres,
      capturedAt: capturedAt,
      placeName: placeName ?? this.placeName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LocationFix &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.accuracyMetres == accuracyMetres &&
        other.capturedAt == capturedAt &&
        other.placeName == placeName;
  }

  @override
  int get hashCode => Object.hash(
    latitude,
    longitude,
    accuracyMetres,
    capturedAt,
    placeName,
  );

  @override
  String toString() => 'LocationFix($label)';
}
