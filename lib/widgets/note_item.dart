import 'package:flutter/material.dart';

import '../data/location/url_launcher_map_launcher.dart';
import '../db/entities/note.dart';
import '../domain/location/location_fix.dart';
import '../domain/location/map_launcher.dart';
import '../domain/location/map_link.dart';
import '../domain/note/note_timestamp.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;

  final MapLauncher mapLauncher;

  const NoteItem({
    super.key,
    required this.note,
    required this.onTap,
    this.mapLauncher = const UrlLauncherMapLauncher(),
  });

  bool get _hasLocation => note.latitude != 0 || note.longtitude != 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.name),
                const SizedBox(height: 10),
                Text(note.body),
                const SizedBox(height: 5),
                if (_hasLocation)
                  _LocationLine(note: note, launcher: mapLauncher),
                _TimestampLine(note: note),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LocationChipLabel {
  const LocationChipLabel._();

  static String forNote(Note note) {
    final String name = note.locationName.trim();
    return name.isNotEmpty
        ? name
        : LocationFix.formatCoordinates(note.latitude, note.longtitude);
  }
}

class _LocationLine extends StatelessWidget {
  const _LocationLine({required this.note, required this.launcher});

  final Note note;
  final MapLauncher launcher;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final String label = LocationChipLabel.forNote(note);

    return Semantics(
      button: true,
      label: 'Open $label in Google Maps',
      child: InkWell(
        onTap: () => launcher.open(
          MapLink(latitude: note.latitude, longitude: note.longtitude),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.pin_drop,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimestampLine extends StatelessWidget {
  const _TimestampLine({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    final String stamp = NoteTimestamp.formatPair(
      note.createdAt,
      note.updatedAt,
    );
    if (stamp.isEmpty) {
      return const SizedBox.shrink();
    }

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextStyle? style = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(Icons.schedule, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              stamp,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}
