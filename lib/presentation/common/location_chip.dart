import 'package:flutter/material.dart';
import 'package:gote/domain/location/location_fix.dart';

enum LocationPillTone { neutral, error }

class LocationChip extends StatelessWidget {
  const LocationChip({
    super.key,
    required this.latitude,
    required this.longitude,
    this.placeName,
    this.onTap,
    this.actionLabel,
    this.onAction,
    this.semanticsLabel,
  });

  final double latitude;
  final double longitude;
  final String? placeName;

  final VoidCallback? onTap;

  final String? actionLabel;
  final VoidCallback? onAction;
  final String? semanticsLabel;

  static String formatCoordinates(double latitude, double longitude) {
    return LocationFix.formatCoordinates(latitude, longitude);
  }

  static String formatAccuracy(double? accuracy) {
    if (accuracy == null) {
      return '';
    }
    return LocationFix.formatAccuracy(accuracy);
  }

  static String labelFor({
    required double latitude,
    required double longitude,
    String? placeName,
  }) {
    final String? name = placeName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return formatCoordinates(latitude, longitude);
  }

  @override
  Widget build(BuildContext context) {
    return LocationStatusPill(
      icon: Icons.location_on,
      label: labelFor(
        latitude: latitude,
        longitude: longitude,
        placeName: placeName,
      ),
      onTap: onTap,
      actionLabel: actionLabel,
      onAction: onAction,
      semanticsLabel: semanticsLabel,
    );
  }
}

class LocationStatusPill extends StatelessWidget {
  const LocationStatusPill({
    super.key,
    required this.icon,
    required this.label,
    this.tone = LocationPillTone.neutral,
    this.busy = false,
    this.onTap,
    this.actionLabel,
    this.onAction,
    this.semanticsLabel,
  });

  final IconData icon;
  final String label;
  final LocationPillTone tone;
  final bool busy;
  final VoidCallback? onTap;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color foreground = tone == LocationPillTone.error
        ? colorScheme.error
        : colorScheme.onSurfaceVariant;

    final Widget pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: tone == LocationPillTone.error
              ? colorScheme.error.withValues(alpha: 0.35)
              : colorScheme.outlineVariant.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          if (busy)
            SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foreground,
              ),
            )
          else
            Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: foreground),
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: foreground,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );

    if (onTap == null) {
      return Semantics(label: semanticsLabel, child: pill);
    }

    return Semantics(
      label: semanticsLabel,
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: pill,
        ),
      ),
    );
  }
}
