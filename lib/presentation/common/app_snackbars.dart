import 'package:flutter/material.dart';

void showAppSnack(
  BuildContext context,
  String message, {
  String? undoLabel,
  VoidCallback? onUndo,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: onUndo == null ? 3 : 5),
        action: onUndo == null
            ? null
            : SnackBarAction(
                label: undoLabel ?? 'Undo',
                onPressed: onUndo,
              ),
      ),
    );
}
