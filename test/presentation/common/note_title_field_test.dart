import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gote/presentation/common/note_content_field.dart';
import 'package:gote/presentation/common/note_title_field.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  BorderRadius fieldRadius(WidgetTester tester) {
    final AnimatedContainer container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    return (container.decoration! as BoxDecoration).borderRadius!
        as BorderRadius;
  }

  group('NoteTitleField', () {
    testWidgets('shows the caption, prompt and an empty counter', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(NoteTitleField(controller: controller)));

      expect(find.text('NOTE NAME'), findsOneWidget);
      expect(find.text('a name for it'), findsOneWidget);
      expect(find.text('0 / 60'), findsOneWidget);
      expect(find.text('Name this note...'), findsOneWidget);
    });

    testWidgets('counter tracks typed and programmatic text', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(NoteTitleField(controller: controller)));

      await tester.enterText(find.byType(TextField), 'grocery list');
      await tester.pump();
      expect(find.text('12 / 60'), findsOneWidget);

      controller.text = 'renamed';
      await tester.pump();
      expect(find.text('7 / 60'), findsOneWidget);
    });

    testWidgets('is a single-line field that hands focus onward', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(NoteTitleField(controller: controller)));

      final TextField field = tester.widget<TextField>(find.byType(TextField));
      expect(field.keyboardType, TextInputType.text);
      expect(field.minLines, 1);
      expect(field.maxLines, 1);
      expect(field.textInputAction, TextInputAction.next);
    });

    testWidgets('rounds all four corners so it reads as its own block', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(NoteTitleField(controller: controller)));

      final BorderRadius radius = fieldRadius(tester);
      expect(radius, BorderRadius.circular(16));
      expect(radius.bottomLeft, const Radius.circular(16));
      expect(radius.bottomRight, const Radius.circular(16));
    });

    testWidgets('renders errorText in the error colour', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          NoteTitleField(
            controller: controller,
            errorText: 'Give the note a name',
          ),
        ),
      );

      final Text error = tester.widget<Text>(
        find.text('Give the note a name'),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(error.style?.color, Theme.of(context).colorScheme.error);
    });

    testWidgets('has no error border past maxLength', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'y' * 61,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(wrap(NoteTitleField(controller: controller)));

      final InputDecorator decorator = tester.widget<InputDecorator>(
        find.byType(InputDecorator),
      );
      expect(decorator.decoration.errorBorder?.borderSide, BorderSide.none);
      expect(
        decorator.decoration.focusedErrorBorder?.borderSide,
        BorderSide.none,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('autofocus takes focus', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteTitleField(controller: controller, autofocus: true)),
      );

      final EditableTextState editable = tester.state<EditableTextState>(
        find.byType(EditableText),
      );
      expect(editable.widget.focusNode.hasFocus, isTrue);
    });

    testWidgets('next action moves focus to the content field', (
      WidgetTester tester,
    ) async {
      final TextEditingController titleController = TextEditingController();
      final TextEditingController bodyController = TextEditingController();
      addTearDown(titleController.dispose);
      addTearDown(bodyController.dispose);

      await tester.pumpWidget(
        wrap(
          Column(
            children: <Widget>[
              NoteTitleField(controller: titleController, autofocus: true),
              NoteContentField(controller: bodyController),
            ],
          ),
        ),
      );
      await tester.pump();

      final EditableTextState title = tester.state<EditableTextState>(
        find.byType(EditableText).first,
      );
      final EditableTextState body = tester.state<EditableTextState>(
        find.byType(EditableText).last,
      );
      expect(title.widget.focusNode.hasFocus, isTrue);
      expect(body.widget.focusNode.hasFocus, isFalse);

      title.widget.focusNode.nextFocus();
      await tester.pump();

      expect(body.widget.focusNode.hasFocus, isTrue);
    });
  });
}
