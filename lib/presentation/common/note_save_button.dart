import 'package:flutter/material.dart';

class NoteSaveButton extends StatelessWidget {
  const NoteSaveButton({
    super.key,
    required this.nameController,
    required this.bodyController,
    required this.onPressed,
    this.label = 'Save',
    this.icon,
  });

  final TextEditingController nameController;
  final TextEditingController bodyController;
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;

  static bool isComplete(
    TextEditingController nameController,
    TextEditingController bodyController,
  ) {
    return nameController.text.trim().isNotEmpty &&
        bodyController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[nameController, bodyController]),
      builder: (BuildContext context, Widget? child) {
        final bool enabled = isComplete(nameController, bodyController);

        return ElevatedButton.icon(
          onPressed: enabled ? onPressed : null,
          icon: Icon(icon ?? Icons.check),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(45),
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
            disabledBackgroundColor: colorScheme.onSurface.withValues(
              alpha: 0.12,
            ),
            disabledForegroundColor: colorScheme.onSurface.withValues(
              alpha: 0.38,
            ),
          ),
        );
      },
    );
  }
}
