import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:campsite/presentation/views/widgets/location_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LocationFilterDialog updates location filter on apply', (WidgetTester tester) async {

    final container = ProviderContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Consumer(
              builder: (context, ref, _) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => LocationFilterDialog(ref: ref),
                ),
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      ),
    );


    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '45.0');
    await tester.enterText(find.byType(TextField).at(1), '-75.0');
    await tester.enterText(find.byType(TextField).at(2), '10');
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();


    final location = container.read(locationProximityProvider);
    expect(location, {
      'lat': 45.0,
      'long': -75.0,
      'radius': 10.0,
    });
  });
}