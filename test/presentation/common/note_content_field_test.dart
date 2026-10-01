import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gote/presentation/common/note_content_field.dart';

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

  group('NoteContentField', () {
    testWidgets('shows the caption, prompt and an empty counter', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

      expect(find.text('NOTE CONTENT'), findsOneWidget);
      expect(find.text('brainstorming'), findsOneWidget);
      expect(find.text('0 / 500'), findsOneWidget);
      expect(find.text('Write a note...'), findsOneWidget);
    });

    testWidgets('counter tracks typed text', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

      await tester.enterText(find.byType(TextField), 'hello');
      await tester.pump();

      expect(find.text('5 / 500'), findsOneWidget);
    });

    testWidgets('counter tracks programmatic text for pre-fill', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'seeded by the edit screen',
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

      expect(find.text('25 / 500'), findsOneWidget);
    });

    testWidgets('renders errorText in the error colour', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(
          NoteContentField(
            controller: controller,
            errorText: 'Note cannot be empty',
          ),
        ),
      );

      final Text error = tester.widget<Text>(
        find.text('Note cannot be empty'),
      );
      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(error.style?.color, Theme.of(context).colorScheme.error);
    });

    testWidgets('has no error border when text exceeds maxLength', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'x' * 501,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

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

    testWidgets('counter keeps the muted colour past maxLength', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController(
        text: 'x' * 501,
      );
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

      final Text counter = tester.widget<Text>(find.text('501 / 500'));
      final BuildContext context = tester.element(find.byType(Scaffold));
      expect(
        counter.style?.color,
        Theme.of(context).colorScheme.onSurfaceVariant,
      );
    });

    testWidgets('rounds only the top corners', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

      final BorderRadius radius = fieldRadius(tester);
      expect(radius.topLeft, const Radius.circular(16));
      expect(radius.topRight, const Radius.circular(16));
      expect(radius.bottomLeft, Radius.zero);
      expect(radius.bottomRight, Radius.zero);
    });

    testWidgets('uses a multiline keyboard', (WidgetTester tester) async {
      final TextEditingController controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        wrap(NoteContentField(controller: controller)),
      );

      final TextField field = tester.widget<TextField>(find.byType(TextField));
      expect(field.keyboardType, TextInputType.multiline);
      expect(field.minLines, 4);
      expect(field.maxLines, 4);
    });

    testWidgets('accepts an externally owned focus node', (
      WidgetTester tester,
    ) async {
      final TextEditingController controller = TextEditingController();
      final FocusNode focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        wrap(
          NoteContentField(controller: controller, focusNode: focusNode),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
      await tester.pumpWidget(wrap(const SizedBox.shrink()));
      expect(focusNode.hasFocus, isFalse);
    });
  });
}
