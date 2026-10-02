import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gote/presentation/common/app_snackbars.dart';
import 'package:gote/screens/note_screen.dart';
import 'package:gote/widgets/note_form.dart';
import 'package:gote/widgets/note_list.dart';

import '../data/location/url_launcher_map_launcher.dart';
import '../db/entities/note.dart';
import '../domain/location/map_launcher.dart';

class HomeScreen extends StatefulWidget {
  final MapLauncher mapLauncher;

  const HomeScreen({
    super.key,
    this.mapLauncher = const UrlLauncherMapLauncher(),
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MapLauncher get mapLauncher => widget.mapLauncher;

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

  void _addNote(Note note) {
    setState(() {
      notes.add(note);
    });
  }

  void _updateNote(int index, Note updated) {
    setState(() {
      notes[index] = updated;
    });
  }

  void _deleteNote(int index, {required bool announce}) {
    final Note removed = notes[index];
    setState(() {
      notes.removeAt(index);
    });
    if (announce) {
      showAppSnack(
        context,
        '"${removed.name}" removed',
        onUndo: () => _restoreNote(index, removed),
      );
    }
  }

  void _restoreNote(int index, Note note) {
    setState(() {
      notes.insert(index.clamp(0, notes.length), note);
    });
  }

  Future<void> _openNote(int index) async {
    final Note note = notes[index];
    final bool? deleted = await Get.to<bool>(
      () => NoteScreen(
        note: note,
        mapLauncher: mapLauncher,
        onSaved: (Note updated) => _updateNote(index, updated),
        onDeleted: () => _deleteNote(index, announce: false),
      ),
      transition: Transition.rightToLeft,
    );
    if (!mounted || deleted != true) {
      return;
    }
    showAppSnack(
      context,
      '"${note.name}" removed',
      onUndo: () => _restoreNote(index, note),
    );
  }

  Future<void> openNoteForm() async {
    final String? message = await showModalBottomSheet<String>(
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) => NoteForm(
        mapLauncher: mapLauncher,
        onSave: (Note note) {
          _addNote(note);
          return 'Note added';
        },
      ),
    );
    if (!mounted || message == null) {
      return;
    }
    showAppSnack(context, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create Note',
        onPressed: openNoteForm,
        child: Icon(Icons.add),
      ),
      body: NoteList(
        mapLauncher: mapLauncher,
        notes: notes,
        onNoteTap: _openNote,
        onNoteDismissed: (int index) => _deleteNote(index, announce: true),
      ),
    );
  }
}
