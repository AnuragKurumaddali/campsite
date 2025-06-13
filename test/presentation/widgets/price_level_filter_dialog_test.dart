import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:campsite/presentation/views/widgets/price_level_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PriceLevelFilterDialog updates selected price levels', (WidgetTester tester) async {

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
                  builder: (_) => PriceLevelFilterDialog(ref: ref),
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
    await tester.tap(find.text('Budget (€0–5000)'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();


    final priceLevels = container.read(priceLevelsProvider);
    expect(priceLevels, ['budget']);
  });
}