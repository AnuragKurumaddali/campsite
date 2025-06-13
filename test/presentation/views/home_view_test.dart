import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/presentation/providers/camp_site_provider.dart';
import 'package:campsite/presentation/views/home_view.dart';
import 'package:campsite/presentation/views/widgets/camp_site_card.dart';
import 'package:campsite/presentation/views/widgets/view_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tCampSite = CampSite(
    id: '1',
    label: 'Test Campsite',
    photo: 'https://example.com/photo.jpg',
    geoLocation: GeoLocation(lat: 45.0, long: -75.0),
    isCloseToWater: true,
    isCampFireAllowed: false,
    hostLanguages: ['en'],
    pricePerNight: 50.0,
    suitableFor: ['Hiking'],
    createdAt: DateTime.utc(2023, 1, 1),
  );

  testWidgets('HomeView displays campsites and toggles view', (WidgetTester tester) async {

    final container = ProviderContainer(
      overrides: [
        campSitesProvider.overrideWith((ref) => Future.value([tCampSite])),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomeView(),
        ),
      ),
    );


    await tester.pumpAndSettle();


    expect(find.byType(CampSiteCard), findsOneWidget);
    expect(find.text('Test Campsite'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);


    final viewToggleFinder = find.byType(ViewToggle).first;
    final gridIconFinder = find.descendant(
      of: viewToggleFinder,
      matching: find.byIcon(Icons.grid_view),
    );
    await tester.ensureVisible(gridIconFinder);
    await tester.tap(gridIconFinder, warnIfMissed: false);
    await tester.pumpAndSettle();



    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Test');
    await tester.pumpAndSettle();
    expect(find.text('Test Campsite'), findsOneWidget);


    await tester.tap(find.text('Close to Water'));
    await tester.pumpAndSettle();
    expect(find.byType(CampSiteCard), findsOneWidget);
  });
}