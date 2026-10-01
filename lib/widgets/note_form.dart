import 'package:flutter/material.dart';
import 'package:gote/presentation/common/note_content_field.dart';
import 'package:gote/presentation/common/note_title_field.dart';

class NoteForm extends StatefulWidget {
  const NoteForm({super.key});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final nameController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: (MediaQuery.of(context).viewInsets.bottom * 1.1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NoteTitleField(controller: nameController),
              const SizedBox(height: 16),
              NoteContentField(controller: bodyController),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(360, 45),
                  backgroundColor: Colors.lightGreen,
                ),
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
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
    );
  }
}
