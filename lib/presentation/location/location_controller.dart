import 'package:flutter/foundation.dart';
import 'package:gote/domain/location/location_fix.dart';
import 'package:gote/domain/location/location_outcome.dart';
import 'package:gote/domain/location/location_repository.dart';

enum LocationStatus { idle, loading, ready, unavailable }

class LocationController extends ChangeNotifier {
  LocationController({required this.repository});

  final LocationRepository repository;

  LocationStatus _status = LocationStatus.idle;
  LocationFix? _fix;
  LocationFailureReason? _reason;
  String? _detail;
  bool _disposed = false;
  bool _inFlight = false;

  LocationStatus get status => _status;
  LocationFix? get fix => _fix;
  LocationFailureReason? get reason => _reason;
  String? get detail => _detail;
  bool get isLoading => _status == LocationStatus.loading;

  void adopt(LocationFix? fix) {
    if (_disposed) {
      return;
    }
    _fix = fix;
    _reason = null;
    _detail = null;
    _status = fix == null ? LocationStatus.idle : LocationStatus.ready;
    _notify();
  }

  Future<void> refresh() async {
    if (_disposed || _inFlight) {
      return;
    }
    _inFlight = true;
    _status = LocationStatus.loading;
    _reason = null;
    _detail = null;
    _notify();

    final LocationOutcome outcome = await repository.currentFix();

    _inFlight = false;
    if (_disposed) {
      return;
    }

    switch (outcome) {
      case LocationAvailable(:final LocationFix fix):
        _fix = fix;
        _reason = null;
        _detail = null;
        _status = LocationStatus.ready;
      case LocationUnavailable(
        :final LocationFailureReason reason,
        :final String? detail,
      ):
        _fix = null;
        _reason = reason;
        _detail = detail;
        _status = LocationStatus.unavailable;
    }
    _notify();
  }

  Future<void> openSettingsAndRetry() async {
    if (_disposed) {
      return;
    }
    await repository.openSettings();
    await refresh();
  }

  void _notify() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
