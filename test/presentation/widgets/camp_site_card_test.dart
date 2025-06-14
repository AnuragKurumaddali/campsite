import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/presentation/views/detail_view.dart';
import 'package:campsite/presentation/views/widgets/camp_site_card.dart';
import 'package:flutter/material.dart';
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

  testWidgets('CampSiteCard displays correctly in list view', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CampSiteCard(campSite: tCampSite, isGridView: false),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test Campsite'), findsOneWidget);
    expect(find.text('€50.00 / night'), findsOneWidget);
    expect(find.text('Near Water'), findsOneWidget);
    expect(find.text('No Campfire'), findsOneWidget);
    expect(find.text('Listed: Jan 1, 2023'), findsOneWidget);
    expect(find.text('Lat: 45.00, Long: -75.00'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('CampSiteCard navigates to DetailView on tap in list view', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CampSiteCard(campSite: tCampSite, isGridView: false),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.byType(DetailView), findsOneWidget);
    expect(find.text('Test Campsite'), findsOneWidget);
  });

  testWidgets('CampSiteCard displays correctly in grid view', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CampSiteCard(campSite: tCampSite, isGridView: true),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test Campsite'), findsOneWidget);
    expect(find.text('€50.00 / night'), findsOneWidget);
    expect(find.text('Lat: 45.00, Long: -75.00'), findsOneWidget);
    expect(find.byIcon(Icons.water), findsOneWidget);
    expect(find.byIcon(Icons.local_fire_department), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}