import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:gote/data/location/place_name_resolver.dart';
import 'package:gote/domain/location/location_fix.dart';
import 'package:gote/domain/location/location_outcome.dart';
import 'package:gote/domain/location/location_repository.dart';

class GeolocatorLocationRepository implements LocationRepository {
  GeolocatorLocationRepository({
    this.timeLimit = const Duration(seconds: 12),
    this.openSettingsTimeout = const Duration(seconds: 2),
    this.placeNameResolver = const GeocodingPlaceNameResolver(),
    this.nameTimeout = const Duration(seconds: 5),
  });

  final Duration timeLimit;
  final Duration openSettingsTimeout;
  final PlaceNameResolver placeNameResolver;

  final Duration nameTimeout;

  @override
  Future<LocationOutcome> currentFix() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationUnavailable(
          LocationFailureReason.serviceDisabled,
        );
      }

      final LocationPermission permission = await _resolvePermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return LocationUnavailable(_reasonFor(permission));
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeLimit,
        ),
      ).timeout(timeLimit);

      return LocationAvailable(await _buildFix(position));
    } on TimeoutException {
      return const LocationUnavailable(LocationFailureReason.timedOut);
    } on LocationServiceDisabledException {
      return const LocationUnavailable(LocationFailureReason.serviceDisabled);
    } on PermissionDeniedException catch (error) {
      return LocationUnavailable(
        _reasonFor(_permissionFromDenial(error)),
        detail: error.message,
      );
    } catch (error) {
      return LocationUnavailable(
        LocationFailureReason.unknown,
        detail: error.toString(),
      );
    }
  }

  @override
  Future<bool> openSettings() async {
    try {
      return await Geolocator.openAppSettings().timeout(openSettingsTimeout);
    } catch (_) {
      return false;
    }
  }

  Future<LocationFix> _buildFix(Position position) async {
    final LocationFix raw = LocationFix(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracyMetres: position.accuracy,
      capturedAt: position.timestamp,
    );

    try {
      final String? name = await placeNameResolver
          .nameFor(
            latitude: position.latitude,
            longitude: position.longitude,
          )
          .timeout(nameTimeout);
      if (name == null || name.trim().isEmpty) {
        return raw;
      }
      return raw.copyWith(placeName: name);
    } catch (_) {
      return raw;
    }
  }

  Future<LocationPermission> _resolvePermission() async {
    final LocationPermission current = await Geolocator.checkPermission();
    if (current == LocationPermission.denied) {
      return Geolocator.requestPermission();
    }
    return current;
  }

  LocationPermission _permissionFromDenial(PermissionDeniedException error) {
    final String message = (error.message ?? '').toLowerCase();
    return message.contains('permanently') || message.contains('forever')
        ? LocationPermission.deniedForever
        : LocationPermission.denied;
  }

  LocationFailureReason _reasonFor(LocationPermission permission) {
    return switch (permission) {
      LocationPermission.denied => LocationFailureReason.permissionDenied,
      LocationPermission.deniedForever =>
        LocationFailureReason.permissionPermanentlyDenied,
      LocationPermission.whileInUse ||
      LocationPermission.always => LocationFailureReason.unknown,
      LocationPermission.unableToDetermine => LocationFailureReason.unknown,
    };
  }
}
