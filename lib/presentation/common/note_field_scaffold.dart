import 'package:flutter/material.dart';

class NoteFieldScaffold extends StatefulWidget {
  const NoteFieldScaffold({
    super.key,
    required this.controller,
    required this.caption,
    required this.hintText,
    required this.maxLength,
    required this.borderRadius,
    this.errorText,
    this.focusNode,
    this.autofocus = false,
    this.prompt = '',
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String caption;
  final String hintText;
  final int maxLength;
  final BorderRadius borderRadius;
  final String? errorText;
  final FocusNode? focusNode;
  final bool autofocus;
  final String prompt;
  final int minLines;
  final int maxLines;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;

  @override
  State<NoteFieldScaffold> createState() => _NoteFieldScaffoldState();
}

class _NoteFieldScaffoldState extends State<NoteFieldScaffold> {
  FocusNode? _ownedFocusNode;

  late final FocusNode _focusNode =
      widget.focusNode ??
      (_ownedFocusNode = FocusNode()..addListener(_handleFocusChange));

  bool _hasFocus = false;

  @override
  void dispose() {
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_hasFocus != _focusNode.hasFocus) {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        ClipRRect(
          borderRadius: widget.borderRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOut,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(
                alpha: _hasFocus ? 0.7 : 0.6,
              ),
              borderRadius: widget.borderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ExcludeSemantics(
                  child: Text(
                    widget.caption,
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 0.8,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: widget.hintText,
                    hintStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.prompt,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Semantics(
                container: true,
                liveRegion: _hasFocus,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.controller,
                  builder:
                      (
                        BuildContext context,
                        TextEditingValue value,
                        Widget? child,
                      ) {
                        return Text(
                          '${value.text.length} / ${widget.maxLength}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText case final String message)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
