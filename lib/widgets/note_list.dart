import 'package:flutter/material.dart';
import 'package:gote/widgets/note_item.dart';

import '../db/entities/note.dart';

class NoteList extends StatelessWidget {
  final List<Note> notes;

  const NoteList({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(notes[index]),
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
        child: NoteItem(note: notes[index]),
      ),
    );
  }
}
