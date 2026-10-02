String? buildPlaceName({
  String? subLocality,
  String? locality,
  String? subAdministrativeArea,
  String? administrativeArea,
  String? thoroughfare,
  String? country,
}) {
  String? clean(String? value) {
    final String? trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  final String? area = clean(subLocality) ?? clean(locality);
  final String? city = clean(locality);
  final String? region =
      clean(subAdministrativeArea) ?? clean(administrativeArea);

  final String? second = region ?? (city != null && city != area ? city : null);

  final String? combined = switch ((area, second)) {
    (final String a, final String b) when a != b => '$a, $b',
    (final String a, _) => a,
    (_, final String b) => b,
    _ => null,
  };

  return combined ?? clean(thoroughfare) ?? clean(country);
}
