import 'package:campsite/domain/entities/camp_site.dart';
import 'package:campsite/presentation/views/detail_view.dart';
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

  testWidgets('DetailView displays campsite details correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DetailView(campSite: tCampSite),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test Campsite'), findsOneWidget);
    expect(find.text('€50.00/night'), findsOneWidget);

    expect(find.text('Close to Water'), findsOneWidget);
    expect(find.text('Available'), findsOneWidget);
    expect(find.text('Campfire Allowed'), findsOneWidget);
    expect(find.text('Not Available'), findsOneWidget);
    expect(find.text('Languages'), findsOneWidget);
    expect(find.text('en'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Lat 45.00, Long -75.00'), findsOneWidget);
    expect(find.text('Listed Since'), findsOneWidget);
    expect(find.text('Jan 1, 2023'), findsOneWidget);
    expect(find.text('Suitable For'), findsOneWidget);
    expect(find.text('Hiking'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Go to Map'), findsOneWidget);
    expect(find.byIcon(Icons.map), findsOneWidget);
  });
}