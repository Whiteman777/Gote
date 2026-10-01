import 'package:flutter/material.dart';
import 'package:gote/core/constants/app_constants.dart';
import 'package:gote/presentation/common/note_field_scaffold.dart';

class NoteTitleField extends StatelessWidget {
  const NoteTitleField({
    super.key,
    required this.controller,
    this.errorText,
    this.focusNode,
    this.autofocus = false,
    this.prompt = defaultPrompt,
  });

  static const String defaultPrompt = 'Name it';

  static const BorderRadius _rounded = BorderRadius.all(Radius.circular(16));

  final TextEditingController controller;
  final String? errorText;
  final FocusNode? focusNode;
  final bool autofocus;
  final String prompt;

  @override
  Widget build(BuildContext context) {
    return NoteFieldScaffold(
      controller: controller,
      caption: 'NOTE NAME',
      hintText: 'Name this note...',
      maxLength: AppConstants.maxNameLength,
      borderRadius: _rounded,
      minLines: 1,
      maxLines: 1,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      errorText: errorText,
      focusNode: focusNode,
      autofocus: autofocus,
      prompt: prompt,
    );
  }
}
