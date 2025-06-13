import 'package:campsite/presentation/providers/filter_providers.dart';
import 'package:campsite/presentation/views/widgets/languages_filter_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LanguagesFilterDialog updates selected languages', (WidgetTester tester) async {

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
                  builder: (_) => LanguagesFilterDialog(ref: ref),
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
    await tester.tap(find.text('EN'));
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();


    final languages = container.read(hostLanguagesProvider);
    expect(languages, ['en']);
  });
}