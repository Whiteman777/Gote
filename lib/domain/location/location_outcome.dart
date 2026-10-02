import 'package:gote/domain/location/location_fix.dart';

enum LocationFailureReason {
  serviceDisabled,

  permissionDenied,

  permissionPermanentlyDenied,

  timedOut,

  unknown,
}

sealed class LocationOutcome {
  const LocationOutcome();
}

final class LocationAvailable extends LocationOutcome {
  const LocationAvailable(this.fix);

  final LocationFix fix;
}

final class LocationUnavailable extends LocationOutcome {
  const LocationUnavailable(this.reason, {this.detail});

  final LocationFailureReason reason;
  final String? detail;

  bool get canRetryInApp =>
      reason != LocationFailureReason.permissionPermanentlyDenied;

  bool get needsSettings =>
      reason == LocationFailureReason.permissionPermanentlyDenied;
}
