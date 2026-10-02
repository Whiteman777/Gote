import 'package:flutter/material.dart';
import 'package:gote/data/location/geolocator_location_repository.dart';
import 'package:gote/db/entities/note.dart';
import 'package:gote/domain/location/location_fix.dart';
import 'package:gote/domain/location/map_launcher.dart';
import 'package:gote/presentation/common/note_content_field.dart';
import 'package:gote/presentation/common/note_location_field.dart';
import 'package:gote/presentation/common/note_save_button.dart';
import 'package:gote/presentation/common/note_title_field.dart';
import 'package:gote/presentation/location/location_controller.dart';

class NoteForm extends StatefulWidget {
  final String? Function(Note note) onSave;

  final LocationController Function() createLocationController;

  final MapLauncher mapLauncher;

  const NoteForm({
    super.key,
    required this.onSave,
    required this.mapLauncher,
    LocationController Function()? createLocationController,
  }) : createLocationController =
           createLocationController ?? _defaultLocationController;

  static LocationController _defaultLocationController() {
    return LocationController(repository: GeolocatorLocationRepository());
  }

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final nameController = TextEditingController();
  final bodyController = TextEditingController();

  late final LocationController locationController;

  bool _attachLocation = false;

  @override
  void initState() {
    super.initState();
    locationController = widget.createLocationController();
  }

  @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: (MediaQuery.of(context).viewInsets.bottom),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              "New Note",
              style: TextStyle(fontSize: 25),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NoteTitleField(controller: nameController),
                      const SizedBox(height: 16),
                      NoteContentField(controller: bodyController),
                      const SizedBox(height: 16),
                      NoteLocationField(
                        value: _attachLocation,
                        onChanged: (bool next) {
                          setState(() {
                            _attachLocation = next;
                          });
                        },
                        controller: locationController,
                        mapLauncher: widget.mapLauncher,
                        activeColor: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      NoteSaveButton(
                        nameController: nameController,
                        bodyController: bodyController,
                        label: 'Save',
                        onPressed: _save,
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(360, 45),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    final LocationFix? fix = _attachLocation ? locationController.fix : null;
    final int now = DateTime.now().millisecondsSinceEpoch;

    final String? message = widget.onSave(
      Note(
        body: bodyController.text,
        name: nameController.text,
        createdAt: now,
        updatedAt: now,
        locationCapturedAt: fix?.capturedAt.millisecondsSinceEpoch ?? 0,
        accuracy: fix?.accuracyMetres ?? 0,
        latitude: fix?.latitude ?? 0,
        longtitude: fix?.longitude ?? 0,
        locationName: fix?.placeName ?? '',
      ),
    );
    Navigator.pop(context, message);
  }
}
