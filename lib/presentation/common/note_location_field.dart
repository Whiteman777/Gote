import 'package:flutter/material.dart';
import 'package:gote/domain/location/location_fix.dart';
import 'package:gote/domain/location/location_outcome.dart';
import 'package:gote/domain/location/map_launcher.dart';
import 'package:gote/domain/location/map_link.dart';
import 'package:gote/presentation/common/location_chip.dart';
import 'package:gote/presentation/location/location_controller.dart';

class NoteLocationField extends StatelessWidget {
  const NoteLocationField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.controller,
    this.activeColor,
    this.mapLauncher,
  });

  static const String caption = 'Attach location to this note';

  final bool value;
  final ValueChanged<bool> onChanged;
  final LocationController controller;
  final Color? activeColor;

  final MapLauncher? mapLauncher;

  void _onToggled(bool? next) {
    final bool attached = next ?? false;
    onChanged(attached);
    if (attached && controller.fix == null) {
      controller.refresh();
    }
  }

  void _openInMaps(LocationFix fix) {
    final MapLauncher? launcher = mapLauncher;
    if (launcher == null) {
      return;
    }
    launcher.open(
      MapLink(latitude: fix.latitude, longitude: fix.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CheckboxListTile(
          value: value,
          onChanged: _onToggled,
          activeColor: activeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(caption),
        ),
        if (value)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) =>
                  _buildStatus(context),
            ),
          ),
      ],
    );
  }

  Widget _buildStatus(BuildContext context) {
    switch (controller.status) {
      case LocationStatus.loading:
        return const LocationStatusPill(
          icon: Icons.location_searching,
          label: 'Finding your location...',
          busy: true,
        );
      case LocationStatus.ready:
        final LocationFix? fix = controller.fix;
        if (fix == null) {
          return LocationStatusPill(
            icon: Icons.location_searching,
            label: 'No fix yet',
            actionLabel: 'Locate',
            onAction: controller.refresh,
          );
        }
        return LocationChip(
          latitude: fix.latitude,
          longitude: fix.longitude,
          placeName: fix.placeName,
          onTap: mapLauncher == null ? null : () => _openInMaps(fix),
          actionLabel: 'Refresh',
          onAction: controller.refresh,
          semanticsLabel: 'Open ${fix.label} in Google Maps',
        );
      case LocationStatus.unavailable:
        final LocationFailureReason reason =
            controller.reason ?? LocationFailureReason.unknown;
        final bool needsSettings =
            reason == LocationFailureReason.permissionPermanentlyDenied;
        return LocationStatusPill(
          icon: needsSettings ? Icons.lock_outline : Icons.location_off,
          label: _describe(reason),
          tone: LocationPillTone.error,
          actionLabel: needsSettings ? 'Settings' : 'Retry',
          onAction: needsSettings
              ? controller.openSettingsAndRetry
              : controller.refresh,
        );
      case LocationStatus.idle:
        return LocationStatusPill(
          icon: Icons.location_searching,
          label: 'No fix yet',
          actionLabel: 'Locate',
          onAction: controller.refresh,
        );
    }
  }

  static String _describe(LocationFailureReason reason) {
    return switch (reason) {
      LocationFailureReason.serviceDisabled => 'Location is switched off',
      LocationFailureReason.permissionDenied => 'Location permission denied',
      LocationFailureReason.permissionPermanentlyDenied =>
        'Permission denied forever',
      LocationFailureReason.timedOut => 'Timed out looking for a fix',
      LocationFailureReason.unknown => 'Could not read your location',
    };
  }
}
