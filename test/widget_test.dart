// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ada_tareas/main.dart';

void main() {
  testWidgets('Test de la aplicación Ada Tareas', (WidgetTester tester) async {
    // Construir la app y disparar un frame
    await tester.pumpWidget(const MyApp());

    // Verificar que existe el título de la app
    expect(find.text('Ada Tareas'), findsOneWidget);

    // Verificar que existe el botón de agregar tarea
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap en el botón de agregar y esperar la navegación
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verificar que estamos en la pantalla de agregar tarea
    expect(find.text('Creando nueva tarea Mi vida❤️'), findsOneWidget);
  });
}
