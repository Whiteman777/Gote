import 'package:flutter/material.dart';
import 'package:gote/core/constants/app_constants.dart';
import 'package:gote/presentation/common/note_field_scaffold.dart';

class NoteContentField extends StatelessWidget {
  const NoteContentField({
    super.key,
    required this.controller,
    this.errorText,
    this.focusNode,
    this.autofocus = false,
    this.prompt = defaultPrompt,
  });

  static const String defaultPrompt = 'Brainstorming';

  static const BorderRadius _topRounded = BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
  );

  final TextEditingController controller;
  final String? errorText;
  final FocusNode? focusNode;
  final bool autofocus;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return NoteFieldScaffold(
      controller: controller,
      caption: 'NOTE CONTENT',
      hintText: 'Write a note...',
      maxLength: AppConstants.maxBodyLength,
      borderRadius: _topRounded,
      minLines: 4,
      maxLines: 4,
      keyboardType: TextInputType.multiline,
      errorText: errorText,
      focusNode: focusNode,
      autofocus: autofocus,
      prompt: prompt,
    );
  }
}
