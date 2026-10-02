import 'package:flutter/material.dart';
import 'package:gote/widgets/note_item.dart';

import '../data/location/url_launcher_map_launcher.dart';
import '../db/entities/note.dart';
import '../domain/location/map_launcher.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;
  final void Function(int index) onNoteTap;
  final void Function(int index) onNoteDismissed;

  final MapLauncher mapLauncher;

  const NoteList({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteDismissed,
    this.mapLauncher = const UrlLauncherMapLauncher(),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(notes[index]),
        onDismissed: (_) => onNoteDismissed(index),
        background: Container(
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Icon(
                Icons.delete_forever,
                size: 35,
              ),
            ),
          ),
        ),
        child: NoteItem(
          note: notes[index],
          onTap: () => onNoteTap(index),
          mapLauncher: mapLauncher,
        ),
      ),
    );
  }
}
