import 'package:flutter/material.dart';
import 'package:gote/widgets/note_form.dart';
import 'package:gote/widgets/note_list.dart';

import '../db/entities/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> notes = [
    Note(
      name: "nigga",
      body: "niggas in paris",
      createdAt: 3,
      updatedAt: 2,
      locationCapturedAt: 2,
      accuracy: 2.2,
      latitude: 2.2,
      longtitude: 112,
    ),
  ];

  void addNote() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => NoteForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNote,
        child: Icon(Icons.add),
      ),
      body: NoteList(notes: notes),
    );
  }
}
