import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipez/features/auth/presentation/widgets/animated_welcome_text.dart';

void main() {
  group('AnimatedWelcomeText', () {
    testWidgets('renderiza correctamente con valores por defecto', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: AnimatedWelcomeText())),
      );

      expect(find.byType(AnimatedWelcomeText), findsOneWidget);
    });

    testWidgets('muestra texto estático cuando reduceAnimation es true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnimatedWelcomeText(reduceAnimation: true)),
        ),
      );

      expect(find.text('Bienvenido a Recipez'), findsOneWidget);
    });

    testWidgets('aplica color personalizado correctamente', (tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedWelcomeText(
              textColor: customColor,
              reduceAnimation: true,
            ),
          ),
        ),
      );

      final container = find.descendant(
        of: find.byType(AnimatedWelcomeText),
        matching: find.byType(Container),
      );

      expect(container, findsOneWidget);

      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.descendant(of: container, matching: find.byType(DefaultTextStyle)),
      );

      expect(defaultTextStyle.style.color, equals(customColor));
    });

    testWidgets('ajusta el tamaño de fuente según el ancho de la pantalla', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AnimatedWelcomeText(reduceAnimation: true)),
        ),
      );

      final container = find.descendant(
        of: find.byType(AnimatedWelcomeText),
        matching: find.byType(Container),
      );

      final defaultTextStyle = tester.widget<DefaultTextStyle>(
        find.descendant(of: container, matching: find.byType(DefaultTextStyle)),
      );

      expect(defaultTextStyle.style.fontSize, isNotNull);
      expect(defaultTextStyle.style.fontSize!, lessThanOrEqualTo(30.0));
      expect(defaultTextStyle.style.fontSize!, greaterThanOrEqualTo(20.0));

      addTearDown(() {
        tester.view.reset();
      });
    });
  });
}
