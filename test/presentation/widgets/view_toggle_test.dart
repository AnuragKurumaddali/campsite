import 'package:campsite/presentation/views/widgets/view_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ViewToggle switches between list and grid view', (WidgetTester tester) async {

    bool isGridView = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ViewToggle(
            isGridView: isGridView,
            onToggle: (value) => isGridView = value,
          ),
        ),
      ),
    );


    await tester.tap(find.byIcon(Icons.grid_view));
    await tester.pumpAndSettle();


    expect(isGridView, isTrue);


    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();


    expect(isGridView, isFalse);
  });
}