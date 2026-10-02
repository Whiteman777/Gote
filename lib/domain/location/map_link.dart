class MapLink {
  const MapLink({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  static Uri googleMapsSearch({
    required double latitude,
    required double longitude,
  }) {
    return Uri.https('www.google.com', '/maps/search/', <String, String>{
      'api': '1',
      'query': '${latitude.toStringAsFixed(4)},${longitude.toStringAsFixed(4)}',
    });
  }

  Uri get uri => googleMapsSearch(latitude: latitude, longitude: longitude);

  @override
  String toString() => uri.toString();
}
