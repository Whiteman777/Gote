import 'package:flutter/material.dart';
import 'package:gote/data/location/geolocator_location_repository.dart';
import 'package:gote/db/entities/note.dart';
import 'package:gote/domain/location/location_fix.dart';
import 'package:gote/domain/location/map_launcher.dart';
import 'package:gote/presentation/common/app_snackbars.dart';
import 'package:gote/presentation/common/note_content_field.dart';
import 'package:gote/presentation/common/note_location_field.dart';
import 'package:gote/presentation/common/note_save_button.dart';
import 'package:gote/presentation/common/note_title_field.dart';
import 'package:gote/presentation/location/location_controller.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({
    super.key,
    required this.note,
    required this.onSaved,
    required this.onDeleted,
    required this.mapLauncher,
    LocationController Function()? createLocationController,
  }) : createLocationController =
           createLocationController ?? _defaultLocationController;

  static LocationController _defaultLocationController() {
    return LocationController(repository: GeolocatorLocationRepository());
  }

  final Note note;
  final ValueChanged<Note> onSaved;
  final VoidCallback onDeleted;

  final LocationController Function() createLocationController;

  final MapLauncher mapLauncher;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final TextEditingController nameController;
  late final TextEditingController bodyController;
  late final LocationController locationController;

  late bool _attachLocation;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.note.name);
    bodyController = TextEditingController(text: widget.note.body);

    final bool hasLocation =
        widget.note.latitude != 0 || widget.note.longtitude != 0;
    _attachLocation = hasLocation;

    locationController = widget.createLocationController();
    if (hasLocation) {
      locationController.adopt(
        LocationFix(
          latitude: widget.note.latitude,
          longitude: widget.note.longtitude,
          accuracyMetres: widget.note.accuracy,
          capturedAt: DateTime.fromMillisecondsSinceEpoch(
            widget.note.locationCapturedAt,
          ),
          placeName: widget.note.locationName.trim().isEmpty
              ? null
              : widget.note.locationName,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Note _buildNote() {
    final LocationFix? fix = _attachLocation ? locationController.fix : null;

    return Note(
      name: nameController.text,
      body: bodyController.text,
      createdAt: widget.note.createdAt,
      updatedAt: DateTime.now().millisecondsSinceEpoch,
      locationCapturedAt: fix?.capturedAt.millisecondsSinceEpoch ?? 0,
      accuracy: fix?.accuracyMetres ?? 0,
      latitude: fix?.latitude ?? 0,
      longtitude: fix?.longitude ?? 0,
      locationName: fix?.placeName ?? '',
    );
  }

  void _toggleLocation(bool next) {
    setState(() {
      _attachLocation = next;
    });

    final String name = nameController.text;
    if (next) {
      showAppSnack(context, 'Location added to "$name"');
      return;
    }
    showAppSnack(
      context,
      'Location removed from "$name"',
      onUndo: () {
        if (!mounted) {
          return;
        }
        setState(() {
          _attachLocation = true;
        });
      },
    );
  }

  void _save() {
    widget.onSaved(_buildNote());
    Navigator.of(context).pop();
  }

  void _delete() {
    widget.onDeleted();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<TextEditingValue>(
          valueListenable: nameController,
          builder:
              (
                BuildContext context,
                TextEditingValue value,
                Widget? child,
              ) {
                return Text(value.text.isEmpty ? 'Untitled note' : value.text);
              },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NoteTitleField(controller: nameController),
                const SizedBox(height: 16),
                NoteContentField(controller: bodyController),
                const SizedBox(height: 16),
                NoteLocationField(
                  value: _attachLocation,
                  onChanged: _toggleLocation,
                  controller: locationController,
                  mapLauncher: widget.mapLauncher,
                  activeColor: Colors.green,
                ),
                const SizedBox(height: 24),
                NoteSaveButton(
                  nameController: nameController,
                  bodyController: bodyController,
                  label: 'Save changes',
                  onPressed: _save,
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: _delete,
                  icon: const Icon(Icons.delete_outline),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(45),
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Colors.white,
                  ),
                  label: const Text('Delete note'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
