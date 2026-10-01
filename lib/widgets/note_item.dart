import 'package:flutter/material.dart';

import '../db/entities/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  const NoteItem({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(12),
      child: Card(
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.name),
                SizedBox(
                  height: 10,
                ),
                Text(
                  note.body,
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(Icons.pin_drop),
                    SizedBox(
                      width: 5,
                    ),
                    Text("${note.accuracy}"),
                    SizedBox(
                      width: 5,
                    ),
                    Text("${note.updatedAt}m "),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
